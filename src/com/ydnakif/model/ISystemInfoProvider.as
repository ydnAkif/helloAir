package com.ydnakif.model {
/**
 * Interface for system information providers.
 */
public interface ISystemInfoProvider {
    /**
     * Get formatted version information.
     */
    function getVersionInfo():String;

    /**
     * Get operating system information.
     */
    function getOSInfo():String;

    /**
     * Get platform label (e.g. "AIR" or "Flash").
     */
    function getPlatformLabel():String;

    /**
     * Check if running on a desktop platform.
     */
    function isDesktop():Boolean;
}
}