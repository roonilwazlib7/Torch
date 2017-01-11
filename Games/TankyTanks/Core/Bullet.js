// Generated by CoffeeScript 1.12.1
(function() {
  var exports,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  exports = this;

  exports.Bullet = (function(superClass) {
    extend(Bullet, superClass);

    Bullet.prototype.shooter = null;

    Bullet.prototype.bounces = 2;

    function Bullet(shooter) {
      var rot, vX, vY;
      this.shooter = shooter;
      Bullet.__super__.constructor.call(this, this.shooter.game, this.shooter.barrel.shootPoint.position.x, this.shooter.barrel.shootPoint.position.y);
      this.Bind.Texture("bullet-silver");
      this.rotation = this.shooter.barrel.rotation;
      this.drawIndex = this.shooter.drawIndex - 1;
      if (this.rotation == null) {
        this.rotation = 0;
      }
      rot = this.rotation - Math.PI / 2;
      vX = Math.cos(rot);
      vY = Math.sin(rot);
      this.Body.velocity.Set(vX, vY);
      this.Body.velocity.MultiplyScalar(0.3);
      this.position.x -= this.rectangle.width / 2;
      this.position.y -= this.rectangle.height / 2;
    }

    Bullet.prototype.Update = function() {
      var dif, flippedX, flippedY;
      Bullet.__super__.Update.call(this);
      flippedY = false;
      flippedX = false;
      if (this.position.y < 0) {
        dif = 0 - this.position.y;
        this.position.y = dif;
        flippedY = true;
      }
      if (this.position.y > this.game.Camera.Viewport.height) {
        dif = this.position.y - this.game.Camera.Viewport.height;
        this.position.y -= dif;
        flippedY = true;
      }
      if (this.position.x < 0) {
        dif = 0 - this.position.x;
        this.position.x = dif;
        flippedX = true;
      }
      if (this.position.x > this.game.Camera.Viewport.width) {
        dif = this.position.x - this.game.Camera.Viewport.width;
        flippedX = true;
      }
      if (flippedY && flippedX) {
        return this.Flip();
      } else if (flippedY) {
        return this.Flip("y");
      } else if (flippedX) {
        return this.Flip("x");
      }
    };

    Bullet.prototype.Flip = function(plane) {
      if (plane == null) {
        plane = "both";
      }
      this.bounces -= 1;
      if (this.bounces <= 0) {
        this.Trash();
        return;
      }
      if (plane === "both") {
        this.Body.velocity.Reverse();
      } else {
        this.Body.velocity[plane] *= -1;
      }
      this.Body.velocity.Resolve();
      return this.rotation = this.Body.velocity.angle + Math.PI / 2;
    };

    Bullet.Load = function(game) {
      return game.Load.Texture("Assets/Art/PNG/Bullets/bulletSilver_outline.png", "bullet-silver");
    };

    return Bullet;

  })(Torch.Sprite);

}).call(this);

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiQnVsbGV0LmpzIiwic291cmNlUm9vdCI6Ii4uXFwuLlxcLi4iLCJzb3VyY2VzIjpbIkdhbWVzXFxUYW5reVRhbmtzXFxTcmNcXEJ1bGxldC5jb2ZmZWUiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IjtBQUFBO0FBQUEsTUFBQSxPQUFBO0lBQUE7OztFQUFBLE9BQUEsR0FBVTs7RUFFSixPQUFPLENBQUM7OztxQkFDVixPQUFBLEdBQVM7O3FCQUNULE9BQUEsR0FBUzs7SUFDSSxnQkFBRSxPQUFGO0FBQ1QsVUFBQTtNQURXLElBQUMsQ0FBQSxVQUFEO01BQ1gsd0NBQU8sSUFBQyxDQUFBLE9BQU8sQ0FBQyxJQUFoQixFQUFzQixJQUFDLENBQUEsT0FBTyxDQUFDLE1BQU0sQ0FBQyxVQUFVLENBQUMsUUFBUSxDQUFDLENBQTFELEVBQTZELElBQUMsQ0FBQSxPQUFPLENBQUMsTUFBTSxDQUFDLFVBQVUsQ0FBQyxRQUFRLENBQUMsQ0FBakc7TUFFQSxJQUFDLENBQUEsSUFBSSxDQUFDLE9BQU4sQ0FBZSxlQUFmO01BRUEsSUFBQyxDQUFBLFFBQUQsR0FBWSxJQUFDLENBQUEsT0FBTyxDQUFDLE1BQU0sQ0FBQztNQUM1QixJQUFDLENBQUEsU0FBRCxHQUFhLElBQUMsQ0FBQSxPQUFPLENBQUMsU0FBVCxHQUFxQjtNQUVsQyxJQUFPLHFCQUFQO1FBQXVCLElBQUMsQ0FBQSxRQUFELEdBQVksRUFBbkM7O01BRUEsR0FBQSxHQUFNLElBQUMsQ0FBQSxRQUFELEdBQVksSUFBSSxDQUFDLEVBQUwsR0FBVTtNQUM1QixFQUFBLEdBQUssSUFBSSxDQUFDLEdBQUwsQ0FBVSxHQUFWO01BQ0wsRUFBQSxHQUFLLElBQUksQ0FBQyxHQUFMLENBQVUsR0FBVjtNQUVMLElBQUMsQ0FBQSxJQUFJLENBQUMsUUFBUSxDQUFDLEdBQWYsQ0FBbUIsRUFBbkIsRUFBdUIsRUFBdkI7TUFDQSxJQUFDLENBQUEsSUFBSSxDQUFDLFFBQVEsQ0FBQyxjQUFmLENBQThCLEdBQTlCO01BQ0EsSUFBQyxDQUFBLFFBQVEsQ0FBQyxDQUFWLElBQWlCLElBQUMsQ0FBQSxTQUFTLENBQUMsS0FBWCxHQUFtQjtNQUNwQyxJQUFDLENBQUEsUUFBUSxDQUFDLENBQVYsSUFBaUIsSUFBQyxDQUFBLFNBQVMsQ0FBQyxNQUFYLEdBQW9CO0lBakI1Qjs7cUJBb0JiLE1BQUEsR0FBUSxTQUFBO0FBQ0osVUFBQTtNQUFBLGlDQUFBO01BQ0EsUUFBQSxHQUFXO01BQ1gsUUFBQSxHQUFXO01BQ1gsSUFBRyxJQUFDLENBQUEsUUFBUSxDQUFDLENBQVYsR0FBYyxDQUFqQjtRQUNJLEdBQUEsR0FBTyxDQUFBLEdBQUksSUFBQyxDQUFBLFFBQVEsQ0FBQztRQUNyQixJQUFDLENBQUEsUUFBUSxDQUFDLENBQVYsR0FBYztRQUNkLFFBQUEsR0FBVyxLQUhmOztNQUlBLElBQUcsSUFBQyxDQUFBLFFBQVEsQ0FBQyxDQUFWLEdBQWMsSUFBQyxDQUFBLElBQUksQ0FBQyxNQUFNLENBQUMsUUFBUSxDQUFDLE1BQXZDO1FBQ0ksR0FBQSxHQUFNLElBQUMsQ0FBQSxRQUFRLENBQUMsQ0FBVixHQUFjLElBQUMsQ0FBQSxJQUFJLENBQUMsTUFBTSxDQUFDLFFBQVEsQ0FBQztRQUMxQyxJQUFDLENBQUEsUUFBUSxDQUFDLENBQVYsSUFBZTtRQUNmLFFBQUEsR0FBVyxLQUhmOztNQUlBLElBQUcsSUFBQyxDQUFBLFFBQVEsQ0FBQyxDQUFWLEdBQWMsQ0FBakI7UUFDSSxHQUFBLEdBQU0sQ0FBQSxHQUFJLElBQUMsQ0FBQSxRQUFRLENBQUM7UUFDcEIsSUFBQyxDQUFBLFFBQVEsQ0FBQyxDQUFWLEdBQWM7UUFDZCxRQUFBLEdBQVcsS0FIZjs7TUFJQSxJQUFHLElBQUMsQ0FBQSxRQUFRLENBQUMsQ0FBVixHQUFjLElBQUMsQ0FBQSxJQUFJLENBQUMsTUFBTSxDQUFDLFFBQVEsQ0FBQyxLQUF2QztRQUNJLEdBQUEsR0FBTSxJQUFDLENBQUEsUUFBUSxDQUFDLENBQVYsR0FBYyxJQUFDLENBQUEsSUFBSSxDQUFDLE1BQU0sQ0FBQyxRQUFRLENBQUM7UUFDMUMsUUFBQSxHQUFXLEtBRmY7O01BSUEsSUFBRyxRQUFBLElBQWEsUUFBaEI7ZUFDSSxJQUFDLENBQUEsSUFBRCxDQUFBLEVBREo7T0FBQSxNQUdLLElBQUcsUUFBSDtlQUFpQixJQUFDLENBQUEsSUFBRCxDQUFNLEdBQU4sRUFBakI7T0FBQSxNQUNBLElBQUcsUUFBSDtlQUFpQixJQUFDLENBQUEsSUFBRCxDQUFNLEdBQU4sRUFBakI7O0lBeEJEOztxQkEwQlIsSUFBQSxHQUFNLFNBQUMsS0FBRDs7UUFBQyxRQUFROztNQUNYLElBQUMsQ0FBQSxPQUFELElBQVk7TUFDWixJQUFHLElBQUMsQ0FBQSxPQUFELElBQVksQ0FBZjtRQUNJLElBQUMsQ0FBQSxLQUFELENBQUE7QUFDQSxlQUZKOztNQUlBLElBQUcsS0FBQSxLQUFTLE1BQVo7UUFDSSxJQUFDLENBQUEsSUFBSSxDQUFDLFFBQVEsQ0FBQyxPQUFmLENBQUEsRUFESjtPQUFBLE1BQUE7UUFHSSxJQUFDLENBQUEsSUFBSSxDQUFDLFFBQVUsQ0FBQSxLQUFBLENBQWhCLElBQTJCLENBQUMsRUFIaEM7O01BS0EsSUFBQyxDQUFBLElBQUksQ0FBQyxRQUFRLENBQUMsT0FBZixDQUFBO2FBQ0EsSUFBQyxDQUFBLFFBQUQsR0FBWSxJQUFDLENBQUEsSUFBSSxDQUFDLFFBQVEsQ0FBQyxLQUFmLEdBQXVCLElBQUksQ0FBQyxFQUFMLEdBQVU7SUFaM0M7O0lBZ0JOLE1BQUMsQ0FBQSxJQUFELEdBQU8sU0FBQyxJQUFEO2FBQ0gsSUFBSSxDQUFDLElBQUksQ0FBQyxPQUFWLENBQW1CLGlEQUFuQixFQUFzRSxlQUF0RTtJQURHOzs7O0tBakVrQixLQUFLLENBQUM7QUFGbkMiLCJzb3VyY2VzQ29udGVudCI6WyJleHBvcnRzID0gdGhpc1xyXG5cclxuY2xhc3MgZXhwb3J0cy5CdWxsZXQgZXh0ZW5kcyBUb3JjaC5TcHJpdGVcclxuICAgIHNob290ZXI6IG51bGwgIyB0aGUgdGFuayB0aGF0IHNob3QgdGhlIGJ1bGxldFxyXG4gICAgYm91bmNlczogMiAgICAjIGhvdyBtYW55IHRpbWVzIHRoZSBidWxsZXQgaXMgYWxsb3dlZCB0byBib3VuY2VcclxuICAgIGNvbnN0cnVjdG9yOiAoIEBzaG9vdGVyICkgLT5cclxuICAgICAgICBzdXBlciggQHNob290ZXIuZ2FtZSwgQHNob290ZXIuYmFycmVsLnNob290UG9pbnQucG9zaXRpb24ueCwgQHNob290ZXIuYmFycmVsLnNob290UG9pbnQucG9zaXRpb24ueSApXHJcblxyXG4gICAgICAgIEBCaW5kLlRleHR1cmUoIFwiYnVsbGV0LXNpbHZlclwiIClcclxuXHJcbiAgICAgICAgQHJvdGF0aW9uID0gQHNob290ZXIuYmFycmVsLnJvdGF0aW9uXHJcbiAgICAgICAgQGRyYXdJbmRleCA9IEBzaG9vdGVyLmRyYXdJbmRleCAtIDFcclxuXHJcbiAgICAgICAgaWYgbm90IEByb3RhdGlvbj8gdGhlbiBAcm90YXRpb24gPSAwXHJcblxyXG4gICAgICAgIHJvdCA9IEByb3RhdGlvbiAtIE1hdGguUEkgLyAyXHJcbiAgICAgICAgdlggPSBNYXRoLmNvcyggcm90IClcclxuICAgICAgICB2WSA9IE1hdGguc2luKCByb3QgKVxyXG5cclxuICAgICAgICBAQm9keS52ZWxvY2l0eS5TZXQodlgsIHZZKVxyXG4gICAgICAgIEBCb2R5LnZlbG9jaXR5Lk11bHRpcGx5U2NhbGFyKDAuMylcclxuICAgICAgICBAcG9zaXRpb24ueCAtPSAoIEByZWN0YW5nbGUud2lkdGggLyAyIClcclxuICAgICAgICBAcG9zaXRpb24ueSAtPSAoIEByZWN0YW5nbGUuaGVpZ2h0IC8gMiApXHJcblxyXG5cclxuICAgIFVwZGF0ZTogLT5cclxuICAgICAgICBzdXBlcigpXHJcbiAgICAgICAgZmxpcHBlZFkgPSBmYWxzZVxyXG4gICAgICAgIGZsaXBwZWRYID0gZmFsc2VcclxuICAgICAgICBpZiBAcG9zaXRpb24ueSA8IDBcclxuICAgICAgICAgICAgZGlmID0gIDAgLSBAcG9zaXRpb24ueVxyXG4gICAgICAgICAgICBAcG9zaXRpb24ueSA9IGRpZlxyXG4gICAgICAgICAgICBmbGlwcGVkWSA9IHRydWVcclxuICAgICAgICBpZiBAcG9zaXRpb24ueSA+IEBnYW1lLkNhbWVyYS5WaWV3cG9ydC5oZWlnaHRcclxuICAgICAgICAgICAgZGlmID0gQHBvc2l0aW9uLnkgLSBAZ2FtZS5DYW1lcmEuVmlld3BvcnQuaGVpZ2h0XHJcbiAgICAgICAgICAgIEBwb3NpdGlvbi55IC09IGRpZlxyXG4gICAgICAgICAgICBmbGlwcGVkWSA9IHRydWVcclxuICAgICAgICBpZiBAcG9zaXRpb24ueCA8IDBcclxuICAgICAgICAgICAgZGlmID0gMCAtIEBwb3NpdGlvbi54XHJcbiAgICAgICAgICAgIEBwb3NpdGlvbi54ID0gZGlmXHJcbiAgICAgICAgICAgIGZsaXBwZWRYID0gdHJ1ZVxyXG4gICAgICAgIGlmIEBwb3NpdGlvbi54ID4gQGdhbWUuQ2FtZXJhLlZpZXdwb3J0LndpZHRoXHJcbiAgICAgICAgICAgIGRpZiA9IEBwb3NpdGlvbi54IC0gQGdhbWUuQ2FtZXJhLlZpZXdwb3J0LndpZHRoXHJcbiAgICAgICAgICAgIGZsaXBwZWRYID0gdHJ1ZVxyXG5cclxuICAgICAgICBpZiBmbGlwcGVkWSBhbmQgZmxpcHBlZFhcclxuICAgICAgICAgICAgQEZsaXAoKVxyXG5cclxuICAgICAgICBlbHNlIGlmIGZsaXBwZWRZIHRoZW4gQEZsaXAoXCJ5XCIpXHJcbiAgICAgICAgZWxzZSBpZiBmbGlwcGVkWCB0aGVuIEBGbGlwKFwieFwiKVxyXG5cclxuICAgIEZsaXA6IChwbGFuZSA9IFwiYm90aFwiKS0+XHJcbiAgICAgICAgQGJvdW5jZXMgLT0gMVxyXG4gICAgICAgIGlmIEBib3VuY2VzIDw9IDBcclxuICAgICAgICAgICAgQFRyYXNoKClcclxuICAgICAgICAgICAgcmV0dXJuXHJcblxyXG4gICAgICAgIGlmIHBsYW5lIGlzIFwiYm90aFwiXHJcbiAgICAgICAgICAgIEBCb2R5LnZlbG9jaXR5LlJldmVyc2UoKVxyXG4gICAgICAgIGVsc2VcclxuICAgICAgICAgICAgQEJvZHkudmVsb2NpdHlbIHBsYW5lIF0gKj0gLTFcclxuXHJcbiAgICAgICAgQEJvZHkudmVsb2NpdHkuUmVzb2x2ZSgpXHJcbiAgICAgICAgQHJvdGF0aW9uID0gQEJvZHkudmVsb2NpdHkuYW5nbGUgKyBNYXRoLlBJIC8gMlxyXG5cclxuXHJcblxyXG4gICAgQExvYWQ6IChnYW1lKSAtPlxyXG4gICAgICAgIGdhbWUuTG9hZC5UZXh0dXJlKCBcIkFzc2V0cy9BcnQvUE5HL0J1bGxldHMvYnVsbGV0U2lsdmVyX291dGxpbmUucG5nXCIsIFwiYnVsbGV0LXNpbHZlclwiIClcclxuIl19
//# sourceURL=C:\dev\Torch\Games\TankyTanks\Src\Bullet.coffee