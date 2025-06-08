package com.ydnakif {
import com.ydnakif.controller.AppController;
import com.ydnakif.model.SystemInfoService;
import com.ydnakif.services.ImageLoaderService;

import flash.display.Sprite;

/**
 * Main application class for HelloAir project.
 *
 * @author Akif Aydın
 * @version 1.0
 * @see ISystemInfoProvider
 * @see IImageLoader
 */
public class HelloAir extends Sprite {
    /**
     * Application entry point.
     */
    public function HelloAir() {
        // Initialize with default dependencies
        var _controller:AppController = new AppController(
                new SystemInfoService(),
                new ImageLoaderService()
        );

        _controller.init(this);
    }
}
}