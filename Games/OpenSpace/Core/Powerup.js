// Generated by CoffeeScript 1.12.1
(function() {
  var BatteryPowerup, LaserPowerup, LifePowerup, ShieldPowerup, exports,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  exports = this;

  exports.Powerup = (function(superClass) {
    extend(Powerup, superClass);

    Powerup.prototype.POWERUP = true;

    Powerup.prototype.textureName = "";

    Powerup.prototype.timeToExisit = 5000;

    Powerup.prototype.timeBeforeTrash = 2000;

    function Powerup(game, x, y) {
      Powerup.__super__.constructor.call(this, game, x, y);
      this.Bind.Texture(this.textureName);
      this.Size.Scale(1, 1);
      this.game.Timer.SetFutureEvent(this.timeToExisit, (function(_this) {
        return function() {
          _this.Effects.Blink();
          return _this.game.Timer.SetFutureEvent(_this.timeBeforeTrash, function() {
            return _this.Trash();
          });
        };
      })(this));
    }

    Powerup.Load = function(game) {
      game.Load.Texture("Assets/Art/PNG/Power-ups/powerupGreen_bolt.png", "powerup-battery");
      game.Load.Texture("Assets/Art/PNG/Power-ups/powerupGreen_shield.png", "powerup-shield");
      game.Load.Texture("Assets/Art/PNG/Power-ups/pill_green.png", "powerup-life");
      return game.Load.Texture("Assets/Art/PNG/Power-ups/PowerupRed_star.png", "powerup-laser");
    };

    Powerup.prototype.ApplyEffect = function(player) {
      this.game.audioPlayer.PlaySound("powerup-1");
      return this.Trash();
    };

    return Powerup;

  })(Torch.Sprite);

  exports.PowerupGenerator = (function() {
    function PowerupGenerator(enemy) {
      this.enemy = enemy;
      this.powerUpPool = new Torch.Util.Math.RandomPool();
      this.powerUpPool.AddChoice(BatteryPowerup, 50);
      this.powerUpPool.AddChoice(LifePowerup, 50);
    }

    PowerupGenerator.prototype.Generate = function() {
      var powerUp;
      powerUp = this.powerUpPool.Pick();
      return new powerUp(this.enemy.game, this.enemy.position.x, this.enemy.position.y);
    };

    return PowerupGenerator;

  })();

  BatteryPowerup = (function(superClass) {
    extend(BatteryPowerup, superClass);

    function BatteryPowerup() {
      return BatteryPowerup.__super__.constructor.apply(this, arguments);
    }

    BatteryPowerup.prototype.textureName = "powerup-battery";

    BatteryPowerup.prototype.ApplyEffect = function(player) {
      BatteryPowerup.__super__.ApplyEffect.call(this);
      return this.game.hud.battery.ReCharge(10);
    };

    return BatteryPowerup;

  })(exports.Powerup);

  LifePowerup = (function(superClass) {
    extend(LifePowerup, superClass);

    function LifePowerup() {
      return LifePowerup.__super__.constructor.apply(this, arguments);
    }

    LifePowerup.prototype.textureName = "powerup-life";

    LifePowerup.prototype.ApplyEffect = function(player) {
      LifePowerup.__super__.ApplyEffect.call(this);
      this.game.hud.playerHealth.ReCharge(10);
      return player.hp += 10;
    };

    return LifePowerup;

  })(exports.Powerup);

  LaserPowerup = (function(superClass) {
    extend(LaserPowerup, superClass);

    function LaserPowerup() {
      return LaserPowerup.__super__.constructor.apply(this, arguments);
    }

    LaserPowerup.prototype.textureName = "powerup-laser";

    LaserPowerup.prototype.ApplyEffect = function(player) {
      return LaserPowerup.__super__.ApplyEffect.call(this);
    };

    return LaserPowerup;

  })(exports.Powerup);

  ShieldPowerup = (function(superClass) {
    extend(ShieldPowerup, superClass);

    function ShieldPowerup() {
      return ShieldPowerup.__super__.constructor.apply(this, arguments);
    }

    ShieldPowerup.prototype.textureName = "powerup-shield";

    ShieldPowerup.prototype.ApplyEffect = function(player) {
      return ShieldPowerup.__super__.ApplyEffect.call(this);
    };

    return ShieldPowerup;

  })(exports.Powerup);

}).call(this);

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiUG93ZXJ1cC5qcyIsInNvdXJjZVJvb3QiOiIuLlxcLi5cXC4uIiwic291cmNlcyI6WyJHYW1lc1xcT3BlblNwYWNlXFxTcmNcXFBvd2VydXAuY29mZmVlIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7QUFBQTtBQUFBLE1BQUEsaUVBQUE7SUFBQTs7O0VBQUEsT0FBQSxHQUFVOztFQUVKLE9BQU8sQ0FBQzs7O3NCQUNWLE9BQUEsR0FBUzs7c0JBQ1QsV0FBQSxHQUFhOztzQkFDYixZQUFBLEdBQWM7O3NCQUNkLGVBQUEsR0FBaUI7O0lBQ0osaUJBQUMsSUFBRCxFQUFPLENBQVAsRUFBVSxDQUFWO01BQ1QseUNBQU8sSUFBUCxFQUFhLENBQWIsRUFBZ0IsQ0FBaEI7TUFDQSxJQUFDLENBQUEsSUFBSSxDQUFDLE9BQU4sQ0FBYyxJQUFDLENBQUEsV0FBZjtNQUNBLElBQUMsQ0FBQSxJQUFJLENBQUMsS0FBTixDQUFZLENBQVosRUFBYyxDQUFkO01BRUEsSUFBQyxDQUFBLElBQUksQ0FBQyxLQUFLLENBQUMsY0FBWixDQUEyQixJQUFDLENBQUEsWUFBNUIsRUFBMEMsQ0FBQSxTQUFBLEtBQUE7ZUFBQSxTQUFBO1VBQ3RDLEtBQUMsQ0FBQSxPQUFPLENBQUMsS0FBVCxDQUFBO2lCQUVBLEtBQUMsQ0FBQSxJQUFJLENBQUMsS0FBSyxDQUFDLGNBQVosQ0FBMkIsS0FBQyxDQUFBLGVBQTVCLEVBQTZDLFNBQUE7bUJBQ3pDLEtBQUMsQ0FBQSxLQUFELENBQUE7VUFEeUMsQ0FBN0M7UUFIc0M7TUFBQSxDQUFBLENBQUEsQ0FBQSxJQUFBLENBQTFDO0lBTFM7O0lBV2IsT0FBQyxDQUFBLElBQUQsR0FBTyxTQUFDLElBQUQ7TUFDSCxJQUFJLENBQUMsSUFBSSxDQUFDLE9BQVYsQ0FBa0IsZ0RBQWxCLEVBQW9FLGlCQUFwRTtNQUNBLElBQUksQ0FBQyxJQUFJLENBQUMsT0FBVixDQUFrQixrREFBbEIsRUFBc0UsZ0JBQXRFO01BQ0EsSUFBSSxDQUFDLElBQUksQ0FBQyxPQUFWLENBQWtCLHlDQUFsQixFQUE2RCxjQUE3RDthQUNBLElBQUksQ0FBQyxJQUFJLENBQUMsT0FBVixDQUFrQiw4Q0FBbEIsRUFBa0UsZUFBbEU7SUFKRzs7c0JBTVAsV0FBQSxHQUFhLFNBQUMsTUFBRDtNQUVULElBQUMsQ0FBQSxJQUFJLENBQUMsV0FBVyxDQUFDLFNBQWxCLENBQTRCLFdBQTVCO2FBQ0EsSUFBQyxDQUFBLEtBQUQsQ0FBQTtJQUhTOzs7O0tBdEJhLEtBQUssQ0FBQzs7RUEyQjlCLE9BQU8sQ0FBQztJQUNHLDBCQUFDLEtBQUQ7TUFBQyxJQUFDLENBQUEsUUFBRDtNQUNWLElBQUMsQ0FBQSxXQUFELEdBQW1CLElBQUEsS0FBSyxDQUFDLElBQUksQ0FBQyxJQUFJLENBQUMsVUFBaEIsQ0FBQTtNQUVuQixJQUFDLENBQUEsV0FBVyxDQUFDLFNBQWIsQ0FBdUIsY0FBdkIsRUFBdUMsRUFBdkM7TUFDQSxJQUFDLENBQUEsV0FBVyxDQUFDLFNBQWIsQ0FBdUIsV0FBdkIsRUFBb0MsRUFBcEM7SUFKUzs7K0JBTWIsUUFBQSxHQUFVLFNBQUE7QUFDTixVQUFBO01BQUEsT0FBQSxHQUFVLElBQUMsQ0FBQSxXQUFXLENBQUMsSUFBYixDQUFBO0FBQ1YsYUFBVyxJQUFBLE9BQUEsQ0FBUyxJQUFDLENBQUEsS0FBSyxDQUFDLElBQWhCLEVBQXNCLElBQUMsQ0FBQSxLQUFLLENBQUMsUUFBUSxDQUFDLENBQXRDLEVBQXlDLElBQUMsQ0FBQSxLQUFLLENBQUMsUUFBUSxDQUFDLENBQXpEO0lBRkw7Ozs7OztFQUlSOzs7Ozs7OzZCQUNGLFdBQUEsR0FBYTs7NkJBRWIsV0FBQSxHQUFhLFNBQUMsTUFBRDtNQUNULDhDQUFBO2FBQ0EsSUFBQyxDQUFBLElBQUksQ0FBQyxHQUFHLENBQUMsT0FBTyxDQUFDLFFBQWxCLENBQTJCLEVBQTNCO0lBRlM7Ozs7S0FIWSxPQUFPLENBQUM7O0VBTy9COzs7Ozs7OzBCQUNGLFdBQUEsR0FBYTs7MEJBRWIsV0FBQSxHQUFhLFNBQUMsTUFBRDtNQUNULDJDQUFBO01BQ0EsSUFBQyxDQUFBLElBQUksQ0FBQyxHQUFHLENBQUMsWUFBWSxDQUFDLFFBQXZCLENBQWdDLEVBQWhDO2FBQ0EsTUFBTSxDQUFDLEVBQVAsSUFBYTtJQUhKOzs7O0tBSFMsT0FBTyxDQUFDOztFQVE1Qjs7Ozs7OzsyQkFDRixXQUFBLEdBQWE7OzJCQUViLFdBQUEsR0FBYSxTQUFDLE1BQUQ7YUFDVCw0Q0FBQTtJQURTOzs7O0tBSFUsT0FBTyxDQUFDOztFQU03Qjs7Ozs7Ozs0QkFDRixXQUFBLEdBQWE7OzRCQUViLFdBQUEsR0FBYSxTQUFDLE1BQUQ7YUFDVCw2Q0FBQTtJQURTOzs7O0tBSFcsT0FBTyxDQUFDO0FBN0RwQyIsInNvdXJjZXNDb250ZW50IjpbImV4cG9ydHMgPSB0aGlzXHJcblxyXG5jbGFzcyBleHBvcnRzLlBvd2VydXAgZXh0ZW5kcyBUb3JjaC5TcHJpdGVcclxuICAgIFBPV0VSVVA6IHRydWVcclxuICAgIHRleHR1cmVOYW1lOiBcIlwiXHJcbiAgICB0aW1lVG9FeGlzaXQ6IDUwMDAgIyBmbGFzaGVzIGFmdGVyIHRoaXNcclxuICAgIHRpbWVCZWZvcmVUcmFzaDogMjAwMFxyXG4gICAgY29uc3RydWN0b3I6IChnYW1lLCB4LCB5KSAtPlxyXG4gICAgICAgIHN1cGVyKCBnYW1lLCB4LCB5IClcclxuICAgICAgICBAQmluZC5UZXh0dXJlKEB0ZXh0dXJlTmFtZSlcclxuICAgICAgICBAU2l6ZS5TY2FsZSgxLDEpXHJcblxyXG4gICAgICAgIEBnYW1lLlRpbWVyLlNldEZ1dHVyZUV2ZW50IEB0aW1lVG9FeGlzaXQsID0+XHJcbiAgICAgICAgICAgIEBFZmZlY3RzLkJsaW5rKClcclxuXHJcbiAgICAgICAgICAgIEBnYW1lLlRpbWVyLlNldEZ1dHVyZUV2ZW50IEB0aW1lQmVmb3JlVHJhc2gsID0+XHJcbiAgICAgICAgICAgICAgICBAVHJhc2goKVxyXG5cclxuICAgIEBMb2FkOiAoZ2FtZSkgLT5cclxuICAgICAgICBnYW1lLkxvYWQuVGV4dHVyZShcIkFzc2V0cy9BcnQvUE5HL1Bvd2VyLXVwcy9wb3dlcnVwR3JlZW5fYm9sdC5wbmdcIiwgXCJwb3dlcnVwLWJhdHRlcnlcIilcclxuICAgICAgICBnYW1lLkxvYWQuVGV4dHVyZShcIkFzc2V0cy9BcnQvUE5HL1Bvd2VyLXVwcy9wb3dlcnVwR3JlZW5fc2hpZWxkLnBuZ1wiLCBcInBvd2VydXAtc2hpZWxkXCIpXHJcbiAgICAgICAgZ2FtZS5Mb2FkLlRleHR1cmUoXCJBc3NldHMvQXJ0L1BORy9Qb3dlci11cHMvcGlsbF9ncmVlbi5wbmdcIiwgXCJwb3dlcnVwLWxpZmVcIilcclxuICAgICAgICBnYW1lLkxvYWQuVGV4dHVyZShcIkFzc2V0cy9BcnQvUE5HL1Bvd2VyLXVwcy9Qb3dlcnVwUmVkX3N0YXIucG5nXCIsIFwicG93ZXJ1cC1sYXNlclwiKVxyXG5cclxuICAgIEFwcGx5RWZmZWN0OiAocGxheWVyKSAtPlxyXG4gICAgICAgICMgc2hvdWxkIGJlIG92ZXJyaWRlbiBieSBkZXNjZW5kZW50IHBvd2VydXBzXHJcbiAgICAgICAgQGdhbWUuYXVkaW9QbGF5ZXIuUGxheVNvdW5kKFwicG93ZXJ1cC0xXCIpXHJcbiAgICAgICAgQFRyYXNoKClcclxuXHJcbmNsYXNzIGV4cG9ydHMuUG93ZXJ1cEdlbmVyYXRvclxyXG4gICAgY29uc3RydWN0b3I6IChAZW5lbXkpIC0+XHJcbiAgICAgICAgQHBvd2VyVXBQb29sID0gbmV3IFRvcmNoLlV0aWwuTWF0aC5SYW5kb21Qb29sKClcclxuXHJcbiAgICAgICAgQHBvd2VyVXBQb29sLkFkZENob2ljZShCYXR0ZXJ5UG93ZXJ1cCwgNTApXHJcbiAgICAgICAgQHBvd2VyVXBQb29sLkFkZENob2ljZShMaWZlUG93ZXJ1cCwgNTApXHJcblxyXG4gICAgR2VuZXJhdGU6IC0+XHJcbiAgICAgICAgcG93ZXJVcCA9IEBwb3dlclVwUG9vbC5QaWNrKClcclxuICAgICAgICByZXR1cm4gbmV3IHBvd2VyVXAoIEBlbmVteS5nYW1lLCBAZW5lbXkucG9zaXRpb24ueCwgQGVuZW15LnBvc2l0aW9uLnkgKVxyXG5cclxuY2xhc3MgQmF0dGVyeVBvd2VydXAgZXh0ZW5kcyBleHBvcnRzLlBvd2VydXBcclxuICAgIHRleHR1cmVOYW1lOiBcInBvd2VydXAtYmF0dGVyeVwiXHJcblxyXG4gICAgQXBwbHlFZmZlY3Q6IChwbGF5ZXIpIC0+XHJcbiAgICAgICAgc3VwZXIoKVxyXG4gICAgICAgIEBnYW1lLmh1ZC5iYXR0ZXJ5LlJlQ2hhcmdlKDEwKVxyXG5cclxuY2xhc3MgTGlmZVBvd2VydXAgZXh0ZW5kcyBleHBvcnRzLlBvd2VydXBcclxuICAgIHRleHR1cmVOYW1lOiBcInBvd2VydXAtbGlmZVwiXHJcblxyXG4gICAgQXBwbHlFZmZlY3Q6IChwbGF5ZXIpIC0+XHJcbiAgICAgICAgc3VwZXIoKVxyXG4gICAgICAgIEBnYW1lLmh1ZC5wbGF5ZXJIZWFsdGguUmVDaGFyZ2UoMTApXHJcbiAgICAgICAgcGxheWVyLmhwICs9IDEwXHJcblxyXG5jbGFzcyBMYXNlclBvd2VydXAgZXh0ZW5kcyBleHBvcnRzLlBvd2VydXBcclxuICAgIHRleHR1cmVOYW1lOiBcInBvd2VydXAtbGFzZXJcIlxyXG5cclxuICAgIEFwcGx5RWZmZWN0OiAocGxheWVyKSAtPlxyXG4gICAgICAgIHN1cGVyKClcclxuXHJcbmNsYXNzIFNoaWVsZFBvd2VydXAgZXh0ZW5kcyBleHBvcnRzLlBvd2VydXBcclxuICAgIHRleHR1cmVOYW1lOiBcInBvd2VydXAtc2hpZWxkXCJcclxuXHJcbiAgICBBcHBseUVmZmVjdDogKHBsYXllcikgLT5cclxuICAgICAgICBzdXBlcigpXHJcbiJdfQ==
//# sourceURL=C:\dev\Torch\Games\OpenSpace\Src\Powerup.coffee