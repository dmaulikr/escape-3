package
{
  import org.flixel.*;

  public class ShockerGroup extends FlxGroup
  {
    public static const SHOCKER_WIDTH:Number = 20;

    private var _side:uint;

    private var _clusterMin:Number = 2;
    private var _clusterMax:Number = 3;

    private var _probability:Number = 0.01;
    private var _prevY:Number = 0;
    private var _topY:Number = 0;
    
    private var _minDistance:Number = 96;
    private var _maxDistance:Number = 16;

    private var _seed:Number = 12345;

    public function ShockerGroup(side:uint):void {
      _side = side;
      maxSize = 50;

      _topY = 0;
      _seed += FlxG.elapsed + side * Math.random();
    }

    public override function update():void {
      // TODO: Change difficulty progression
      if(GameTracker.score > 500) {
        _probability = 0.015;
        _maxDistance = 64;
        _minDistance = 48;
      } else if(GameTracker.score > 300) {
        _clusterMin = 3;
        _minDistance = 64;
        _maxDistance = 80;
      } else if(GameTracker.score > 200) {
        _maxDistance = 96;
      } else if(GameTracker.score > 100) {
        _clusterMax = 4;
        _minDistance = 80;
        _maxDistance = 128;
      }

      if(FlxG.camera.scroll.y < _topY) {
        _topY = FlxG.camera.scroll.y;
      }

      if(FlxG.camera.scroll.y < _prevY) {
        _prevY = FlxG.camera.scroll.y;

        var randNum:Number = Math.abs(FlxU.srand(_seed)); 
        _seed += randNum;
        if(randNum < _probability || _topY >= _maxDistance) {
          var amt:Number = Math.abs(FlxU.srand(_seed));
          _seed += amt;
          amt *= _clusterMax;
          if(amt < _clusterMin)
            amt = _clusterMin;

          for(var i:int = 0; i < amt; i++) {
            var s:Shocker = recycle(Shocker) as Shocker;
            s.x = (_side == FlxObject.LEFT ? 16 : FlxG.width - SHOCKER_WIDTH - 16);
            s.y = _topY - 16;
            if(_side == FlxObject.LEFT)
              s.y -= 32;
            s.side = _side;

            _topY -= 16
          }

          _topY -= _minDistance;
        }
      }

      super.update();
    }
  }
}
