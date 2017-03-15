// Generated by CoffeeScript 1.12.1
(function() {
  var SimpleExplosion, exports,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  exports = this;

  exports.EffectGenerator = (function() {
    function EffectGenerator(game1) {
      this.game = game1;
    }

    EffectGenerator.prototype.CreateSimpleExplosion = function(x, y) {
      var ex;
      ex = new SimpleExplosion(this.game, x, y);
      return ex;
    };

    return EffectGenerator;

  })();

  SimpleExplosion = (function(superClass) {
    extend(SimpleExplosion, superClass);

    function SimpleExplosion(game, x, y) {
      var atlas, firstFrame;
      atlas = game.Assets.GetTextureAtlas("simple-explosion");
      firstFrame = atlas.textures["simpleExplosion00"];
      SimpleExplosion.__super__.constructor.call(this, game, x - firstFrame.width / 2, y - firstFrame.height / 2);
      this.Size.Scale(2, 2);
      this.drawIndex = 5000;
      this.Animations.AtlasFrame("simple-explosion", "simple-explosion", ["simpleExplosion00", "simpleExplosion01", "simpleExplosion02", "simpleExplosion03", "simpleExplosion04", "simpleExplosion05", "simpleExplosion06", "simpleExplosion07", "simpleExplosion08"], {
        step: 40
      }).On("Finish", (function(_this) {
        return function() {
          return _this.Trash();
        };
      })(this));
    }

    return SimpleExplosion;

  })(Torch.Sprite);

}).call(this);

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiRWZmZWN0R2VuZXJhdG9yLmpzIiwic291cmNlUm9vdCI6Ii4uXFwuLlxcLi4iLCJzb3VyY2VzIjpbIkdhbWVzXFxPcGVuU3BhY2VcXFNyY1xcRWZmZWN0R2VuZXJhdG9yLmNvZmZlZSJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiO0FBQUE7QUFBQSxNQUFBLHdCQUFBO0lBQUE7OztFQUFBLE9BQUEsR0FBVTs7RUFDSixPQUFPLENBQUM7SUFDRyx5QkFBQyxLQUFEO01BQUMsSUFBQyxDQUFBLE9BQUQ7SUFBRDs7OEJBRWIscUJBQUEsR0FBdUIsU0FBQyxDQUFELEVBQUksQ0FBSjtBQUNuQixVQUFBO01BQUEsRUFBQSxHQUFTLElBQUEsZUFBQSxDQUFnQixJQUFDLENBQUEsSUFBakIsRUFBdUIsQ0FBdkIsRUFBMEIsQ0FBMUI7QUFDVCxhQUFPO0lBRlk7Ozs7OztFQUlyQjs7O0lBQ1cseUJBQUMsSUFBRCxFQUFPLENBQVAsRUFBVSxDQUFWO0FBQ1QsVUFBQTtNQUFBLEtBQUEsR0FBUSxJQUFJLENBQUMsTUFBTSxDQUFDLGVBQVosQ0FBNkIsa0JBQTdCO01BQ1IsVUFBQSxHQUFhLEtBQUssQ0FBQyxRQUFVLENBQUEsbUJBQUE7TUFFN0IsaURBQU8sSUFBUCxFQUFhLENBQUEsR0FBSSxVQUFVLENBQUMsS0FBWCxHQUFpQixDQUFsQyxFQUFxQyxDQUFBLEdBQUksVUFBVSxDQUFDLE1BQVgsR0FBa0IsQ0FBM0Q7TUFFQSxJQUFDLENBQUEsSUFBSSxDQUFDLEtBQU4sQ0FBWSxDQUFaLEVBQWMsQ0FBZDtNQUNBLElBQUMsQ0FBQSxTQUFELEdBQWE7TUFHYixJQUFDLENBQUEsVUFBVSxDQUFDLFVBQVosQ0FBd0Isa0JBQXhCLEVBQTRDLGtCQUE1QyxFQUFnRSxDQUN4RCxtQkFEd0QsRUFFeEQsbUJBRndELEVBR3hELG1CQUh3RCxFQUl4RCxtQkFKd0QsRUFLeEQsbUJBTHdELEVBTXhELG1CQU53RCxFQU94RCxtQkFQd0QsRUFReEQsbUJBUndELEVBU3hELG1CQVR3RCxDQUFoRSxFQVVPO1FBQUEsSUFBQSxFQUFLLEVBQUw7T0FWUCxDQVVnQixDQUFDLEVBVmpCLENBVW9CLFFBVnBCLEVBVThCLENBQUEsU0FBQSxLQUFBO2VBQUEsU0FBQTtpQkFDdEIsS0FBQyxDQUFBLEtBQUQsQ0FBQTtRQURzQjtNQUFBLENBQUEsQ0FBQSxDQUFBLElBQUEsQ0FWOUI7SUFWUzs7OztLQURhLEtBQUssQ0FBQztBQVJwQyIsInNvdXJjZXNDb250ZW50IjpbImV4cG9ydHMgPSB0aGlzXHJcbmNsYXNzIGV4cG9ydHMuRWZmZWN0R2VuZXJhdG9yXHJcbiAgICBjb25zdHJ1Y3RvcjogKEBnYW1lKSAtPlxyXG5cclxuICAgIENyZWF0ZVNpbXBsZUV4cGxvc2lvbjogKHgsIHkpIC0+XHJcbiAgICAgICAgZXggPSBuZXcgU2ltcGxlRXhwbG9zaW9uKEBnYW1lLCB4LCB5KVxyXG4gICAgICAgIHJldHVybiBleFxyXG5cclxuY2xhc3MgU2ltcGxlRXhwbG9zaW9uIGV4dGVuZHMgVG9yY2guU3ByaXRlXHJcbiAgICBjb25zdHJ1Y3RvcjogKGdhbWUsIHgsIHkpIC0+XHJcbiAgICAgICAgYXRsYXMgPSBnYW1lLkFzc2V0cy5HZXRUZXh0dXJlQXRsYXMoIFwic2ltcGxlLWV4cGxvc2lvblwiIClcclxuICAgICAgICBmaXJzdEZyYW1lID0gYXRsYXMudGV4dHVyZXNbIFwic2ltcGxlRXhwbG9zaW9uMDBcIiBdXHJcblxyXG4gICAgICAgIHN1cGVyKCBnYW1lLCB4IC0gZmlyc3RGcmFtZS53aWR0aC8yLCB5IC0gZmlyc3RGcmFtZS5oZWlnaHQvMiApXHJcblxyXG4gICAgICAgIEBTaXplLlNjYWxlKDIsMilcclxuICAgICAgICBAZHJhd0luZGV4ID0gNTAwMFxyXG5cclxuXHJcbiAgICAgICAgQEFuaW1hdGlvbnMuQXRsYXNGcmFtZSggXCJzaW1wbGUtZXhwbG9zaW9uXCIsIFwic2ltcGxlLWV4cGxvc2lvblwiLCBbXHJcbiAgICAgICAgICAgICAgICBcInNpbXBsZUV4cGxvc2lvbjAwXCJcclxuICAgICAgICAgICAgICAgIFwic2ltcGxlRXhwbG9zaW9uMDFcIlxyXG4gICAgICAgICAgICAgICAgXCJzaW1wbGVFeHBsb3Npb24wMlwiXHJcbiAgICAgICAgICAgICAgICBcInNpbXBsZUV4cGxvc2lvbjAzXCJcclxuICAgICAgICAgICAgICAgIFwic2ltcGxlRXhwbG9zaW9uMDRcIlxyXG4gICAgICAgICAgICAgICAgXCJzaW1wbGVFeHBsb3Npb24wNVwiXHJcbiAgICAgICAgICAgICAgICBcInNpbXBsZUV4cGxvc2lvbjA2XCJcclxuICAgICAgICAgICAgICAgIFwic2ltcGxlRXhwbG9zaW9uMDdcIlxyXG4gICAgICAgICAgICAgICAgXCJzaW1wbGVFeHBsb3Npb24wOFwiXHJcbiAgICAgICAgICAgIF0sIHN0ZXA6NDAgKS5PbiBcIkZpbmlzaFwiLCA9PlxyXG4gICAgICAgICAgICAgICAgQFRyYXNoKClcclxuIl19
//# sourceURL=C:\dev\Torch\Games\OpenSpace\Src\EffectGenerator.coffee