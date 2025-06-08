package com.ydnakif.controller {
import com.ydnakif.model.ISystemInfoProvider;
import com.ydnakif.services.IImageLoader;
import com.ydnakif.view.AppView;

import flash.display.Sprite;

/**
 * Main application controller coordinating model-view interaction.
 */
public class AppController {
    /**
     * @param systemInfo System information provider
     * @param imageLoader Image loading service
     */
    public function AppController(
            systemInfo:ISystemInfoProvider,
            imageLoader:IImageLoader
    ) {
        _systemInfo = systemInfo;
        _imageLoader = imageLoader;
    }

    private var _systemInfo:ISystemInfoProvider;
    private var _imageLoader:IImageLoader;

    /**
     * Initialize application with stage container.
     * @param stageContainer Main display container
     */
    public function init(stageContainer:Sprite):void {
        var _view:AppView = new AppView(_systemInfo, _imageLoader);
        stageContainer.addChild(_view);
    }
}
}