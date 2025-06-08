package com.ydnakif.services {
import flash.display.Loader;
import flash.net.URLRequest;

/**
 * Default implementation of image loading service.
 */
public class ImageLoaderService implements IImageLoader {
    /**
     * @inheritDoc
     */
    public function loadImage(loader:Loader, url:String):void {
        loader.load(new URLRequest(url));
    }
}
}