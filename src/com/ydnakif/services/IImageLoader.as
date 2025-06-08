package com.ydnakif.services {
import flash.display.Loader;

/**
 * Interface for image loading services.
 */
public interface IImageLoader {
    /**
     * Load image into specified loader.
     * @param loader Target loader instance
     * @param url Image URL to load
     */
    function loadImage(loader:Loader, url:String):void;
}
}