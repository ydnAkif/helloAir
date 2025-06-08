package com.ydnakif.model {
import flash.system.Capabilities;

/**
 * Default implementation of system information provider.
 */
public class SystemInfoService implements ISystemInfoProvider {
    /**
     * @inheritDoc
     */
    public function getVersionInfo():String {
        var versionParts:Array = Capabilities.version.split(" ");
        return (versionParts.length > 1) ?
                versionParts[1].replace(/,/g, ".") : "Unknown";
    }

    /**
     * @inheritDoc
     */
    public function getOSInfo():String {
        var osRaw:String = Capabilities.os;
        if (osRaw.indexOf("Mac OS") != -1) {
            var macVersionMatch:Array = osRaw.match(/\d+\.\d+(\.\d+)?/);
            return "macOS Sonoma " + (macVersionMatch ? macVersionMatch[0] : "Unknown");
        }
        return osRaw;
    }

    /**
     * @inheritDoc
     */
    public function getPlatformLabel():String {
        return Capabilities.playerType == "Desktop" ?
                "Adobe AIR Version" : "Flash Player Version";
    }

    /**
     * @inheritDoc
     */
    public function isDesktop():Boolean {
        return Capabilities.playerType == "Desktop";
    }
}
}