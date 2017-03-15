// Generated by CoffeeScript 1.12.1
(function() {
  var Shield, exports,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  exports = this;

  exports.Player = (function(superClass) {
    extend(Player, superClass);

    Player.prototype.velocity = 0.4;

    Player.prototype.bulletFireDelay = 100;

    Player.prototype.bulletFiredAt = 0;

    Player.prototype.bulletVelocity = 1.5;

    Player.prototype.hp = 100;

    Player.prototype.PLAYER = true;

    Player.prototype._recoverTime = 2000;

    Player.prototype._recovering = false;

    Player.prototype.blinkEffect = null;

    function Player(game) {
      Player.__super__.constructor.call(this, game, 0, 0);
      this.Bind.Texture("player");
      this.Effects.Trail();
      this.Center();
      this.SetUpCollisions();
      this.bulletVector = new Torch.Vector(1, 1);
      this.position.y = this.game.Camera.Viewport.height - this.rectangle.height * 2;
      this.drawIndex = 5;
      this.shield = new Shield(this);
      this.On("Damaged", (function(_this) {
        return function(event) {
          _this.hp -= event.damage;
          return _this.game.hud.playerHealth.Deplete(event.damage);
        };
      })(this));
      this.game.On("Lose", (function(_this) {
        return function() {
          return _this.Trash();
        };
      })(this));
    }

    Player.Load = function(game) {
      game.Load.Texture("Assets/Art/PNG/playerShip1_blue.png", "player");
      return game.Load.Texture("Assets/Art/PNG/Effects/shield3.png", "shield");
    };

    Player.prototype.Update = function() {
      Player.__super__.Update.call(this);
      this.HandleHealth();
      this.HandleShooting();
      this.HandleShield();
      return this.HandleMovement();
    };

    Player.prototype.FireBullet = function() {
      var cordX, cordY, p1, rot, x, y;
      if (this.game.hud.battery.charge <= 0) {
        return;
      }
      rot = this.rotation - Math.PI / 2;
      cordX = Math.cos(rot);
      cordY = Math.sin(rot);
      this.game.hud.battery.Deplete(1);
      x = this.position.x + ((this.rectangle.width / 2) * cordX) + this.rectangle.width / 2;
      y = this.position.y + ((this.rectangle.height / 2) * cordY) + this.rectangle.height / 2;
      p1 = new Projectile(this, {
        direction: this.bulletVector,
        x: x,
        y: y
      });
      p1.position.x -= p1.rectangle.width / 2;
      p1.position.y -= p1.rectangle.height / 2;
      return this.game.audioPlayer.PlaySound("laser-shoot-1");
    };

    Player.prototype.SetUpCollisions = function() {
      this.Collisions.Monitor();
      return this.On("Collision", (function(_this) {
        return function(event) {
          return _this.HandleCollision(event);
        };
      })(this));
    };

    Player.prototype.HandleShield = function() {
      var keys;
      keys = this.game.Keys;
      if (keys.P.down) {
        return this.shield.Activate();
      } else {
        return this.shield.Activate(false);
      }
    };

    Player.prototype.HandleShooting = function() {
      var m, v;
      v = this.position.Clone();
      v.x += this.rectangle.width / 2;
      v.y += this.rectangle.height / 2;
      m = new Torch.Vector(this.game.Mouse.x, this.game.Mouse.y);
      v.SubtractVector(m);
      v.Normalize();
      this.rotation = -v.angle;
      v.MultiplyScalar(-1 * this.bulletVelocity);
      this.bulletVector = v;
      if (this.game.Mouse.down && (this.game.time - this.bulletFiredAt) >= this.bulletFireDelay) {
        this.bulletFiredAt = this.game.time;
        return this.FireBullet();
      }
    };

    Player.prototype.HandleMovement = function() {
      var keys;
      keys = this.game.Keys;
      this.Body.velocity.Set(0, 0);
      if (keys.A.down) {
        this.Body.velocity.Set(-this.velocity, 0);
      }
      if (keys.D.down) {
        this.Body.velocity.Set(this.velocity, 0);
      }
      if (keys.S.down) {
        this.Body.velocity.Set(0, this.velocity);
      }
      if (keys.W.down) {
        return this.Body.velocity.Set(0, -this.velocity);
      }
    };

    Player.prototype.HandleHealth = function() {
      if (this.hp <= 0) {
        return this.game.State.Switch("lose");
      }
    };

    Player.prototype.HandleCollision = function(event) {
      var obj;
      obj = event.collisionData.collider;
      if (obj.ENEMY && !this._recovering) {
        this.HandleEnemyCollision(obj);
      }
      if (obj.POWERUP) {
        return this.HandlePowerupCollision(obj);
      }
    };

    Player.prototype.HandleEnemyCollision = function(enemy) {
      this.Emit("Damaged", {
        damage: enemy.damage
      });
      enemy.Kill();
      this.blinkEffect = this.Effects.Blink(100);
      this._recovering = true;
      return this.game.Timer.SetFutureEvent(this._recoverTime, (function(_this) {
        return function() {
          _this.blinkEffect.Trash();
          _this._recovering = false;
          return _this.opacity = 1;
        };
      })(this));
    };

    Player.prototype.HandlePowerupCollision = function(powerup) {
      return powerup.ApplyEffect(this);
    };

    return Player;

  })(Torch.Sprite);

  Shield = (function(superClass) {
    extend(Shield, superClass);

    Shield.prototype.SHIELD = true;

    Shield.prototype.active = false;

    function Shield(player) {
      this.player = player;
      Shield.__super__.constructor.call(this, this.player.game, this.player.position.x, this.player.position.y);
      this.Bind.Texture("shield");
      this.Size.Scale(1, 1);
      this.draw = false;
      this.game.Tweens.Tween(this, 1000, Torch.Easing.Smooth).To({
        opacity: 0.4
      }).Cycle();
    }

    Shield.prototype.Update = function() {
      Shield.__super__.Update.call(this);
      this.position.x = this.player.position.x - this.rectangle.width / 5.5;
      return this.position.y = this.player.position.y - this.rectangle.height / 5;
    };

    Shield.prototype.Activate = function(turnOn) {
      if (turnOn == null) {
        turnOn = true;
      }
      this.active = turnOn;
      return this.draw = turnOn;
    };

    return Shield;

  })(Torch.Sprite);

}).call(this);

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiUGxheWVyLmpzIiwic291cmNlUm9vdCI6Ii4uXFwuLlxcLi4iLCJzb3VyY2VzIjpbIkdhbWVzXFxPcGVuU3BhY2VcXFNyY1xcUGxheWVyLmNvZmZlZSJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiO0FBQUE7QUFBQSxNQUFBLGVBQUE7SUFBQTs7O0VBQUEsT0FBQSxHQUFVOztFQUNKLE9BQU8sQ0FBQzs7O3FCQUNWLFFBQUEsR0FBVTs7cUJBQ1YsZUFBQSxHQUFpQjs7cUJBQ2pCLGFBQUEsR0FBZTs7cUJBQ2YsY0FBQSxHQUFnQjs7cUJBQ2hCLEVBQUEsR0FBSTs7cUJBQ0osTUFBQSxHQUFROztxQkFFUixZQUFBLEdBQWM7O3FCQUNkLFdBQUEsR0FBYTs7cUJBQ2IsV0FBQSxHQUFhOztJQUNBLGdCQUFDLElBQUQ7TUFDVCx3Q0FBTyxJQUFQLEVBQWEsQ0FBYixFQUFnQixDQUFoQjtNQUVBLElBQUMsQ0FBQSxJQUFJLENBQUMsT0FBTixDQUFjLFFBQWQ7TUFDQSxJQUFDLENBQUEsT0FBTyxDQUFDLEtBQVQsQ0FBQTtNQUVBLElBQUMsQ0FBQSxNQUFELENBQUE7TUFDQSxJQUFDLENBQUEsZUFBRCxDQUFBO01BRUEsSUFBQyxDQUFBLFlBQUQsR0FBb0IsSUFBQSxLQUFLLENBQUMsTUFBTixDQUFhLENBQWIsRUFBZSxDQUFmO01BQ3BCLElBQUMsQ0FBQSxRQUFRLENBQUMsQ0FBVixHQUFjLElBQUMsQ0FBQSxJQUFJLENBQUMsTUFBTSxDQUFDLFFBQVEsQ0FBQyxNQUF0QixHQUErQixJQUFDLENBQUEsU0FBUyxDQUFDLE1BQVgsR0FBb0I7TUFDakUsSUFBQyxDQUFBLFNBQUQsR0FBYTtNQUNiLElBQUMsQ0FBQSxNQUFELEdBQWMsSUFBQSxNQUFBLENBQU8sSUFBUDtNQUVkLElBQUMsQ0FBQSxFQUFELENBQUksU0FBSixFQUFlLENBQUEsU0FBQSxLQUFBO2VBQUEsU0FBQyxLQUFEO1VBQ1gsS0FBQyxDQUFBLEVBQUQsSUFBTyxLQUFLLENBQUM7aUJBRWIsS0FBQyxDQUFB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RCxDQUFxRSxDQUFDLEtBQXRFLENBQUE7SUFQUzs7cUJBU2IsTUFBQSxHQUFRLFNBQUE7TUFDSixpQ0FBQTtNQUNBLElBQUMsQ0FBQSxRQUFRLENBQUMsQ0FBVixHQUFjLElBQUMsQ0FBQSxNQUFNLENBQUMsUUFBUSxDQUFDLENBQWpCLEdBQXFCLElBQUMsQ0FBQSxTQUFTLENBQUMsS0FBWCxHQUFtQjthQUN0RCxJQUFDLENBQUEsUUFBUSxDQUFDLENBQVYsR0FBYyxJQUFDLENBQUEsTUFBTSxDQUFDLFFBQVEsQ0FBQyxDQUFqQixHQUFxQixJQUFDLENBQUEsU0FBUyxDQUFDLE1BQVgsR0FBb0I7SUFIbkQ7O3FCQUtSLFFBQUEsR0FBVSxTQUFDLE1BQUQ7O1FBQUMsU0FBUzs7TUFDaEIsSUFBQyxDQUFBLE1BQUQsR0FBVTthQUVWLElBQUMsQ0FBQSxJQUFELEdBQVE7SUFIRjs7OztLQWpCTyxLQUFLLENBQUM7QUEzSTNCIiwic291cmNlc0NvbnRlbnQiOlsiZXhwb3J0cyA9IHRoaXNcclxuY2xhc3MgZXhwb3J0cy5QbGF5ZXIgZXh0ZW5kcyBUb3JjaC5TcHJpdGVcclxuICAgIHZlbG9jaXR5OiAwLjRcclxuICAgIGJ1bGxldEZpcmVEZWxheTogMTAwXHJcbiAgICBidWxsZXRGaXJlZEF0OiAwXHJcbiAgICBidWxsZXRWZWxvY2l0eTogMS41XHJcbiAgICBocDogMTAwXHJcbiAgICBQTEFZRVI6IHRydWVcclxuXHJcbiAgICBfcmVjb3ZlclRpbWU6IDIwMDBcclxuICAgIF9yZWNvdmVyaW5nOiBmYWxzZVxyXG4gICAgYmxpbmtFZmZlY3Q6IG51bGxcclxuICAgIGNvbnN0cnVjdG9yOiAoZ2FtZSkgLT5cclxuICAgICAgICBzdXBlciggZ2FtZSwgMCwgMCApXHJcblxyXG4gICAgICAgIEBCaW5kLlRleHR1cmUoXCJwbGF5ZXJcIilcclxuICAgICAgICBARWZmZWN0cy5UcmFpbCgpXHJcblxyXG4gICAgICAgIEBDZW50ZXIoKVxyXG4gICAgICAgIEBTZXRVcENvbGxpc2lvbnMoKVxyXG5cclxuICAgICAgICBAYnVsbGV0VmVjdG9yID0gbmV3IFRvcmNoLlZlY3RvcigxLDEpXHJcbiAgICAgICAgQHBvc2l0aW9uLnkgPSBAZ2FtZS5DYW1lcmEuVmlld3BvcnQuaGVpZ2h0IC0gQHJlY3RhbmdsZS5oZWlnaHQgKiAyXHJcbiAgICAgICAgQGRyYXdJbmRleCA9IDVcclxuICAgICAgICBAc2hpZWxkID0gbmV3IFNoaWVsZChAKVxyXG5cclxuICAgICAgICBAT24gXCJEYW1hZ2VkXCIsIChldmVudCkgPT5cclxuICAgICAgICAgICAgQGhwIC09IGV2ZW50LmRhbWFnZVxyXG5cclxuICAgICAgICAgICAgQGdhbWUuaHVkLnBsYXllckhlYWx0aC5EZXBsZXRlKCBldmVudC5kYW1hZ2UgKVxyXG5cclxuICAgICAgICBAZ2FtZS5PbiBcIkxvc2VcIiwgPT5cclxuICAgICAgICAgICAgQFRyYXNoKCkgIyBtYXliZSBhZGQgYW4gZWZmZXRjIGhlcmU/XHJcblxyXG4gICAgQExvYWQ6IChnYW1lKSAtPlxyXG4gICAgICAgIGdhbWUuTG9hZC5UZXh0dXJlKFwiQXNzZXRzL0FydC9QTkcvcGxheWVyU2hpcDFfYmx1ZS5wbmdcIiwgXCJwbGF5ZXJcIilcclxuICAgICAgICBnYW1lLkxvYWQuVGV4dHVyZShcIkFzc2V0cy9BcnQvUE5HL0VmZmVjdHMvc2hpZWxkMy5wbmdcIiwgXCJzaGllbGRcIilcclxuXHJcbiAgICBVcGRhdGU6IC0+XHJcbiAgICAgICAgc3VwZXIoKVxyXG4gICAgICAgIEBIYW5kbGVIZWFsdGgoKVxyXG4gICAgICAgIEBIYW5kbGVTaG9vdGluZygpXHJcbiAgICAgICAgQEhhbmRsZVNoaWVsZCgpXHJcbiAgICAgICAgQEhhbmRsZU1vdmVtZW50KClcclxuXHJcbiAgICBGaXJlQnVsbGV0OiAtPlxyXG4gICAgICAgIHJldHVybiBpZiBAZ2FtZS5odWQuYmF0dGVyeS5jaGFyZ2UgPD0gMFxyXG4gICAgICAgIHJvdCA9IEByb3RhdGlvbiAtIE1hdGguUEkvMlxyXG4gICAgICAgIGNvcmRYID0gTWF0aC5jb3MoIHJvdCApXHJcbiAgICAgICAgY29yZFkgPSBNYXRoLnNpbiggcm90IClcclxuXHJcbiAgICAgICAgQGdhbWUuaHVkLmJhdHRlcnkuRGVwbGV0ZSgxKVxyXG5cclxuICAgICAgICB4ID0gQHBvc2l0aW9uLnggKyAoIChAcmVjdGFuZ2xlLndpZHRoIC8gMikgKiBjb3JkWCApICsgQHJlY3RhbmdsZS53aWR0aC8yXHJcbiAgICAgICAgeSA9IEBwb3NpdGlvbi55ICsgKCAoQHJlY3RhbmdsZS5oZWlnaHQgLyAyKSAqIGNvcmRZICkgKyBAcmVjdGFuZ2xlLmhlaWdodC8yXHJcblxyXG5cclxuICAgICAgICBwMSA9IG5ldyBQcm9qZWN0aWxlIEAsXHJcbiAgICAgICAgICAgIGRpcmVjdGlvbjogQGJ1bGxldFZlY3RvclxyXG4gICAgICAgICAgICB4OiB4XHJcbiAgICAgICAgICAgIHk6IHlcclxuXHJcbiAgICAgICAgcDEucG9zaXRpb24ueCAtPSBwMS5yZWN0YW5nbGUud2lkdGgvMlxyXG4gICAgICAgIHAxLnBvc2l0aW9uLnkgLT0gcDEucmVjdGFuZ2xlLmhlaWdodC8yXHJcblxyXG4gICAgICAgIEBnYW1lLmF1ZGlvUGxheWVyLlBsYXlTb3VuZCggXCJsYXNlci1zaG9vdC0xXCIgKVxyXG5cclxuICAgIFNldFVwQ29sbGlzaW9uczogLT5cclxuICAgICAgICBAQ29sbGlzaW9ucy5Nb25pdG9yKClcclxuICAgICAgICBAT24gXCJDb2xsaXNpb25cIiwgKGV2ZW50KSA9PlxyXG4gICAgICAgICAgICBASGFuZGxlQ29sbGlzaW9uKGV2ZW50KVxyXG5cclxuICAgIEhhbmRsZVNoaWVsZDogLT5cclxuICAgICAgICBrZXlzID0gQGdhbWUuS2V5c1xyXG5cclxuICAgICAgICBpZiBrZXlzLlAuZG93blxyXG4gICAgICAgICAgICBAc2hpZWxkLkFjdGl2YXRlKClcclxuICAgICAgICBlbHNlXHJcbiAgICAgICAgICAgIEBzaGllbGQuQWN0aXZhdGUoZmFsc2UpXHJcblxyXG4gICAgSGFuZGxlU2hvb3Rpbmc6IC0+XHJcbiAgICAgICAgdiA9IEBwb3NpdGlvbi5DbG9uZSgpXHJcbiAgICAgICAgdi54ICs9IEByZWN0YW5nbGUud2lkdGggLyAyXHJcbiAgICAgICAgdi55ICs9IEByZWN0YW5nbGUuaGVpZ2h0IC8yXHJcblxyXG4gICAgICAgIG0gPSBuZXcgVG9yY2guVmVjdG9yKCBAZ2FtZS5Nb3VzZS54LCBAZ2FtZS5Nb3VzZS55IClcclxuXHJcbiAgICAgICAgdi5TdWJ0cmFjdFZlY3RvciggbSApXHJcbiAgICAgICAgdi5Ob3JtYWxpemUoKVxyXG4gICAgICAgIEByb3RhdGlvbiA9IC12LmFuZ2xlXHJcblxyXG4gICAgICAgIHYuTXVsdGlwbHlTY2FsYXIoIC0xICogQGJ1bGxldFZlbG9jaXR5IClcclxuICAgICAgICBAYnVsbGV0VmVjdG9yID0gdlxyXG5cclxuICAgICAgICBpZiBAZ2FtZS5Nb3VzZS5kb3duIGFuZCAoIEBnYW1lLnRpbWUgLSBAYnVsbGV0RmlyZWRBdCApID49IEBidWxsZXRGaXJlRGVsYXlcclxuICAgICAgICAgICAgQGJ1bGxldEZpcmVkQXQgPSBAZ2FtZS50aW1lXHJcbiAgICAgICAgICAgIEBGaXJlQnVsbGV0KClcclxuXHJcbiAgICBIYW5kbGVNb3ZlbWVudDogLT5cclxuICAgICAgICBrZXlzID0gQGdhbWUuS2V5c1xyXG5cclxuICAgICAgICBAQm9keS52ZWxvY2l0eS5TZXQoMCwwKVxyXG5cclxuICAgICAgICBpZiBrZXlzLkEuZG93blxyXG4gICAgICAgICAgICBAQm9keS52ZWxvY2l0eS5TZXQoLUB2ZWxvY2l0eSwwKVxyXG4gICAgICAgIGlmIGtleXMuRC5kb3duXHJcbiAgICAgICAgICAgIEBCb2R5LnZlbG9jaXR5LlNldChAdmVsb2NpdHksMClcclxuICAgICAgICBpZiBrZXlzLlMuZG93blxyXG4gICAgICAgICAgICBAQm9keS52ZWxvY2l0eS5TZXQoMCxAdmVsb2NpdHkpXHJcbiAgICAgICAgaWYga2V5cy5XLmRvd25cclxuICAgICAgICAgICAgQEJvZHkudmVsb2NpdHkuU2V0KDAsLUB2ZWxvY2l0eSlcclxuXHJcbiAgICBIYW5kbGVIZWFsdGg6IC0+XHJcbiAgICAgICAgaWYgQGhwIDw9IDBcclxuICAgICAgICAgICAgQGdhbWUuU3RhdGUuU3dpdGNoKFwibG9zZVwiKVxyXG5cclxuICAgIEhhbmRsZUNvbGxpc2lvbjogKGV2ZW50KSAtPlxyXG4gICAgICAgIG9iaiA9IGV2ZW50LmNvbGxpc2lvbkRhdGEuY29sbGlkZXJcclxuXHJcbiAgICAgICAgaWYgb2JqLkVORU1ZIGFuZCBub3QgQF9yZWNvdmVyaW5nXHJcbiAgICAgICAgICAgIEBIYW5kbGVFbmVteUNvbGxpc2lvbihvYmopXHJcblxyXG4gICAgICAgIGlmIG9iai5QT1dFUlVQXHJcbiAgICAgICAgICAgIEBIYW5kbGVQb3dlcnVwQ29sbGlzaW9uKG9iailcclxuXHJcbiAgICBIYW5kbGVFbmVteUNvbGxpc2lvbjogKGVuZW15KSAtPlxyXG4gICAgICAgIEBFbWl0KCBcIkRhbWFnZWRcIiwgZGFtYWdlOmVuZW15LmRhbWFnZSApXHJcbiAgICAgICAgZW5lbXkuS2lsbCgpXHJcbiAgICAgICAgQGJsaW5rRWZmZWN0ID0gQEVmZmVjdHMuQmxpbmsoMTAwKVxyXG4gICAgICAgIEBfcmVjb3ZlcmluZyA9IHRydWVcclxuXHJcbiAgICAgICAgQGdhbWUuVGltZXIuU2V0RnV0dXJlRXZlbnQgQF9yZWNvdmVyVGltZSwgPT5cclxuICAgICAgICAgICAgQGJsaW5rRWZmZWN0LlRyYXNoKClcclxuICAgICAgICAgICAgQF9yZWNvdmVyaW5nID0gZmFsc2VcclxuICAgICAgICAgICAgQG9wYWNpdHkgPSAxXHJcblxyXG4gICAgSGFuZGxlUG93ZXJ1cENvbGxpc2lvbjogKHBvd2VydXApIC0+XHJcbiAgICAgICAgcG93ZXJ1cC5BcHBseUVmZmVjdChAKVxyXG5cclxuY2xhc3MgU2hpZWxkIGV4dGVuZHMgVG9yY2guU3ByaXRlXHJcbiAgICBTSElFTEQ6IHRydWVcclxuICAgIGFjdGl2ZTogZmFsc2VcclxuICAgIGNvbnN0cnVjdG9yOiAoQHBsYXllcikgLT5cclxuICAgICAgICBzdXBlciggQHBsYXllci5nYW1lLCBAcGxheWVyLnBvc2l0aW9uLngsIEBwbGF5ZXIucG9zaXRpb24ueSApXHJcbiAgICAgICAgQEJpbmQuVGV4dHVyZShcInNoaWVsZFwiKVxyXG4gICAgICAgIEBTaXplLlNjYWxlKDEsMSlcclxuICAgICAgICBAZHJhdyA9IGZhbHNlXHJcblxyXG4gICAgICAgICMgbWFrZSBpdCBibGluayBhIGxpdHRsZVxyXG4gICAgICAgIEBnYW1lLlR3ZWVucy5Ud2VlbiggQCwgMTAwMCwgVG9yY2guRWFzaW5nLlNtb290aCApLlRvKCBvcGFjaXR5OiAwLjQgKS5DeWNsZSgpXHJcblxyXG4gICAgVXBkYXRlOiAtPlxyXG4gICAgICAgIHN1cGVyKClcclxuICAgICAgICBAcG9zaXRpb24ueCA9IEBwbGF5ZXIucG9zaXRpb24ueCAtIEByZWN0YW5nbGUud2lkdGggLyA1LjVcclxuICAgICAgICBAcG9zaXRpb24ueSA9IEBwbGF5ZXIucG9zaXRpb24ueSAtIEByZWN0YW5nbGUuaGVpZ2h0IC8gNVxyXG5cclxuICAgIEFjdGl2YXRlOiAodHVybk9uID0gdHJ1ZSkgLT5cclxuICAgICAgICBAYWN0aXZlID0gdHVybk9uXHJcblxyXG4gICAgICAgIEBkcmF3ID0gdHVybk9uXHJcbiJdfQ==
//# sourceURL=C:\dev\Torch\Games\OpenSpace\Src\Player.coffee