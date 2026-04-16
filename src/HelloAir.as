package
{
  import flash.display.Sprite;
  import flash.display.Loader;
  import flash.display.Bitmap;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.net.URLRequest;
  import flash.system.Capabilities;
  import flash.text.TextField;
  import flash.text.TextFormat;
  import flash.text.TextFieldAutoSize;
  import flash.events.IOErrorEvent;
  import flash.ui.Mouse;
  import flash.ui.MouseCursor;

  public class HelloAir extends Sprite
  {
    private var outputField:TextField;
    private var outputFormat:TextFormat;
    private var logoLoader:Loader;

    public function HelloAir()
    {
      // --- Platforma göre görsel seç ---
      var tip:String = Capabilities.playerType;
      var imageFile:String = (tip == "Desktop") ? "assets/air.png" : "assets/flash.png";

      // --- Loader ile resmi yükle ---
      // Düzeltme #6: logoLoader önce ekleniyor (alt katman)
      logoLoader = new Loader();
      logoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
      logoLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onImageLoadError);
      logoLoader.load(new URLRequest(imageFile));
      addChild(logoLoader);

      // --- Metin Kutusu Ayarları ---
      // Düzeltme #6: outputField sonra ekleniyor (üst katman)
      outputField = new TextField();
      outputFormat = new TextFormat("Arial", 24, 0x000000, true);
      outputFormat.align = "center";
      outputField.defaultTextFormat = outputFormat;
      outputField.autoSize = TextFieldAutoSize.CENTER;
      outputField.selectable = false;
      outputField.multiline = true;
      outputField.visible = false;
      addChild(outputField);

      // --- Tıklama olaylarını dinle ---
      logoLoader.addEventListener(MouseEvent.CLICK, onLogoClick);
      logoLoader.addEventListener(MouseEvent.MOUSE_OVER, onLogoOver); // Düzeltme #4: el imleci
      logoLoader.addEventListener(MouseEvent.MOUSE_OUT, onLogoOut); // Düzeltme #4: el imleci
      outputField.addEventListener(MouseEvent.CLICK, onTextClick);

      // Düzeltme #5: stage henüz hazır olmayabilir, ADDED_TO_STAGE dinle
      addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    // Düzeltme #5: Stage hazır olduğunda resize dinleyicisini ekle
    private function onAddedToStage(e:Event):void
    {
      removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

      // Düzeltme #3: Pencere boyutu değişince logoyu yeniden konumlandır
      stage.addEventListener(Event.RESIZE, onStageResize);

      // Görsel zaten yüklendiyse ama stage yokken konumlandırılamamışsa şimdi konumlandır
      positionLogo();
    }

    private function onImageLoaded(e:Event):void
    {
      // Düzeltme #1: bmp null kontrolü
      var bmp:Bitmap = logoLoader.content as Bitmap;
      if (bmp == null)
      {
        trace("Loaded content is not a Bitmap.");
        return;
      }
      bmp.smoothing = true;

      positionLogo();
    }

    // Düzeltme #3: Yeniden kullanılabilir konumlandırma metodu
    private function positionLogo():void
    {
      if (logoLoader == null || logoLoader.content == null)
        return;

      var bmp:Bitmap = logoLoader.content as Bitmap;
      if (bmp == null)
        return;

      if (stage)
      {
        var scale:Number = Math.min(stage.stageWidth / bmp.width, stage.stageHeight / bmp.height, 1) * 0.8;
        bmp.scaleX = bmp.scaleY = scale;
        bmp.x = (stage.stageWidth - bmp.width) / 2;
        bmp.y = (stage.stageHeight - bmp.height) / 2;
      }
      else
      {
        trace("Stage is not available yet.");
      }
    }

    // Düzeltme #3: Pencere resize olduğunda logoyu yeniden konumlandır
    private function onStageResize(e:Event):void
    {
      positionLogo();
    }

    // Düzeltme #4: el imleci — Mouse.cursor ile manuel kontrol
    private function onLogoOver(e:MouseEvent):void
    {
      Mouse.cursor = MouseCursor.BUTTON;
    }

    private function onLogoOut(e:MouseEvent):void
    {
      Mouse.cursor = MouseCursor.AUTO;
    }

    private function onImageLoadError(e:IOErrorEvent):void
    {
      trace("Error loading image: " + e.text);
    }

    private function onLogoClick(e:MouseEvent):void
    {
      var versionRaw:String = Capabilities.version;
      var osRaw:String = Capabilities.os;

      // Flash/AIR sürümünü al
      var versionParts:Array = versionRaw.split(" ");
      var flashVersion:String = (versionParts.length > 1) ? versionParts[1].replace(/,/g, ".") : "Unknown";

      // İşletim sistemi adını al
      var osName:String = "Unknown OS";
      if (osRaw.indexOf("Mac OS") != -1)
      {
        // Düzeltme #2: "macOS Sonoma" hardcode kaldırıldı, versiyon numarası dinamik
        var macVersionMatch:Array = osRaw.match(/\d+\.\d+(\.\d+)?/);
        var macVersion:String = (macVersionMatch != null) ? macVersionMatch[0] : "Unknown";
        osName = "macOS " + macVersion;
      }
      else
      {
        osName = osRaw;
      }

      // Platform bilgilerini göster
      var platformLabel:String = (Capabilities.playerType == "Desktop") ? "Adobe AIR Version" : "Flash Player Version";
      outputField.text = platformLabel + ": " + flashVersion + "\n" + osName;
      outputField.setTextFormat(outputFormat);
      outputField.x = (stage.stageWidth - outputField.width) / 2;
      outputField.y = stage.stageHeight / 2 - 50;

      logoLoader.visible = false;
      outputField.visible = true;
    }

    private function onTextClick(e:MouseEvent):void
    {
      outputField.visible = false;
      logoLoader.visible = true;
    }
  }
}
