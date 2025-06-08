package com.ydnakif.view {

import com.ydnakif.model.ISystemInfoProvider;
import com.ydnakif.services.IImageLoader;

import flash.display.Bitmap;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

/**
 * The AppView class is responsible for rendering the application's UI.
 * It displays a platform-specific image or system information based on user interaction.
 */
public class AppView extends Sprite {
    /**
     * Constructor for the AppView class.
     * @param systemInfo An instance of ISystemInfoProvider to retrieve system information.
     * @param imageLoader An instance of IImageLoader to handle image loading.
     */
    public function AppView(systemInfo:ISystemInfoProvider, imageLoader:IImageLoader) {
        _systemInfo = systemInfo;
        _imageLoader = imageLoader;
        init();
    }

    // UI Components
    private var _outputField:TextField; // Text field to display system information or error messages.
    private var _logoLoader:Loader; // Loader to display the platform-specific image.

    // Dependencies
    private var _systemInfo:ISystemInfoProvider; // Provides system information.
    private var _imageLoader:IImageLoader; // Handles image loading.

    // State
    private var _originalBitmapWidth:Number = 0; // Original width of the loaded bitmap.
    private var _originalBitmapHeight:Number = 0; // Original height of the loaded bitmap.

    /**
     * Initializes the view by creating UI components and loading the platform image.
     */
    private function init():void {
        createUIComponents();
        loadPlatformImage();
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    /**
     * Creates and configures the UI components (text field and image loader).
     */
    private function createUIComponents():void {
        var textFormat:TextFormat = new TextFormat("Arial", 24, 0x000000, true, null, null, null, null, "center");

        _outputField = new TextField();
        _outputField.defaultTextFormat = textFormat;
        _outputField.autoSize = TextFieldAutoSize.CENTER;
        _outputField.selectable = false;
        _outputField.multiline = true;
        _outputField.visible = false;
        addChild(_outputField);

        _logoLoader = new Loader();
        addChild(_logoLoader);
    }

    /**
     * Loads the platform-specific image based on the system type.
     * Adds event listeners for image loading and user interaction.
     */
    private function loadPlatformImage():void {
        try {
            var imageFile:String = _systemInfo.isDesktop() ? "assets/air.png" : "assets/flash.png";
            _imageLoader.loadImage(_logoLoader, imageFile);
            _logoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
            _logoLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onImageLoadError);
            _logoLoader.addEventListener(MouseEvent.CLICK, onLogoClick);
            _outputField.addEventListener(MouseEvent.CLICK, onTextClick);
        } catch (e:Error) {
            trace("Image load failed:", e.message);
        }
    }

    /**
     * Centers the UI elements (text field or image) on the stage.
     */
    private function centerElements():void {
        if (!stage)
            return;

        if (_outputField.visible) {
            centerTextField();
        } else if (_logoLoader.content) {
            centerImage();
        }
    }

    /**
     * Centers the loaded image on the stage and scales it proportionally.
     */
    private function centerImage():void {
        var bmp:Bitmap = _logoLoader.content as Bitmap;
        var scale:Number = Math.min(
                stage.stageWidth / _originalBitmapWidth,
                stage.stageHeight / _originalBitmapHeight,
                1
        ) * 0.8;

        bmp.scaleX = bmp.scaleY = scale;
        bmp.x = (stage.stageWidth - bmp.width) / 2;
        bmp.y = (stage.stageHeight - bmp.height) / 2;
    }

    /**
     * Centers the text field on the stage.
     */
    private function centerTextField():void {
        _outputField.x = (stage.stageWidth - _outputField.width) / 2;
        _outputField.y = (stage.stageHeight - _outputField.height) / 2;
    }

    /**
     * Displays system information in the text field and hides the image.
     */
    private function showSystemInfo():void {
        _outputField.text = _systemInfo.getPlatformLabel() + ": " +
                _systemInfo.getVersionInfo() + "\n" +
                _systemInfo.getOSInfo();
        _outputField.visible = true;
        _logoLoader.visible = false;
        centerElements();
    }

    /**
     * Toggles between displaying the text field and the image.
     */
    private function toggleView():void {
        _outputField.visible = !_outputField.visible;
        _logoLoader.visible = !_logoLoader.visible;
        centerElements();
    }

    /**
     * Handles the ADDED_TO_STAGE event to set up stage-related listeners and layout.
     * @param e The event object.
     */
    private function onAddedToStage(e:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        stage.addEventListener(Event.RESIZE, onStageResize);
        centerElements();
    }

    /**
     * Handles the COMPLETE event when the image is successfully loaded.
     * @param e The event object.
     */
    private function onImageLoaded(e:Event):void {
        var bmp:Bitmap = _logoLoader.content as Bitmap;
        if (bmp) {
            bmp.smoothing = true;
            _originalBitmapWidth = bmp.width;
            _originalBitmapHeight = bmp.height;
            centerElements();
        }
    }

    /**
     * Handles the IO_ERROR event when the image fails to load.
     * Displays an error message in the text field.
     * @param e The event object.
     */
    private function onImageLoadError(e:IOErrorEvent):void {
        _outputField.text = "Error loading image\nClick to retry";
        _outputField.visible = true;
        centerElements();
    }

    /**
     * Handles the CLICK event on the image to display system information.
     * @param e The event object.
     */
    private function onLogoClick(e:MouseEvent):void {
        showSystemInfo();
    }

    /**
     * Handles the CLICK event on the text field to toggle the view.
     * @param e The event object.
     */
    private function onTextClick(e:MouseEvent):void {
        toggleView();
    }

    /**
     * Handles the RESIZE event to re-center UI elements when the stage size changes.
     * @param e The event object.
     */
    private function onStageResize(e:Event):void {
        centerElements();
    }
}
}