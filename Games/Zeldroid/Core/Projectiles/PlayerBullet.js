// Generated by CoffeeScript 1.12.1
(function() {
  var exports,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  exports = this;

  exports.PlayerBullet = (function(superClass) {
    extend(PlayerBullet, superClass);

    PlayerBullet.prototype.DAMAGE = 1;

    function PlayerBullet(shooter) {
      this.InitSprite(shooter.game, shooter.position.x, shooter.position.y);
      this.Bind.Texture("player-bullet");
      this.drawIndex = shooter.drawIndex + 1;
      this.shooter = shooter;
      this.VELOCITY = 1.5;
      switch (shooter.facing) {
        case "forward":
          this.Body.velocity.y = -1 * this.VELOCITY;
          this.position.y -= 0.3 * shooter.rectangle.height;
          this.position.x += 0.1 * shooter.rectangle.width;
          break;
        case "backward":
          this.Body.velocity.y = 1 * this.VELOCITY;
          this.position.x += 0.1 * shooter.rectangle.width;
          this.position.y += 0.3 * shooter.rectangle.height;
          break;
        case "right":
          this.Body.velocity.x = 1 * this.VELOCITY;
          this.position.x += 1.1 * shooter.rectangle.width;
          this.position.y += 0.25 * shooter.rectangle.height;
          this.rotation = Math.PI / 2;
          break;
        case "left":
          this.Body.velocity.x = -1 * this.VELOCITY;
          this.position.x -= 0.1 * shooter.rectangle.width;
          this.position.y += 0.25 * shooter.rectangle.height;
          this.rotation = Math.PI / 2;
      }
      this.Size.Scale(10, 10);
      this.emitter = this.game.Particles.ParticleEmitter(500, 500, 500, true, "shoot-particle", {
        spread: 20,
        gravity: 0.0001,
        minAngle: 0,
        maxAngle: Math.PI * 2,
        minScale: 2,
        maxScale: 4,
        minVelocity: 0.01,
        maxVelocity: 0.01,
        minAlphaDecay: 200,
        maxAlphaDecay: 250,
        minOmega: 0.001,
        maxOmega: 0.001
      });
      this.emitter.auto = false;
      this.emitter.position = this.position.Clone();
      this.emitter.EmitParticles(true);
      this.Collisions.Monitor();
      this.On("Collision", (function(_this) {
        return function(event) {
          if (!event.collisionData.collider.hardBlock) {
            return;
          }
          event.collisionData.collider.BulletHit(_this);
          _this.Trash();
          _this.emitter.particle = "particle";
          _this.emitter.position = _this.position.Clone();
          _this.emitter.EmitParticles(true);
          return _this.shooter.audioPlayer.PlaySound("shoot-explode");
        };
      })(this));
    }

    PlayerBullet.prototype.Update = function() {
      PlayerBullet.__super__.Update.call(this);
      if (this.Body.distance >= 500) {
        return this.Trash();
      }
    };

    return PlayerBullet;

  })(Torch.Sprite);

}).call(this);

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiUGxheWVyQnVsbGV0LmpzIiwic291cmNlUm9vdCI6Ii4uXFwuLlxcLi5cXC4uIiwic291cmNlcyI6WyJHYW1lc1xcWmVsZHJvaWRcXFNyY1xcUHJvamVjdGlsZXNcXFBsYXllckJ1bGxldC5jb2ZmZWUiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IjtBQUFBO0FBQUEsTUFBQSxPQUFBO0lBQUE7OztFQUFBLE9BQUEsR0FBVTs7RUFFSixPQUFPLENBQUM7OzsyQkFDVixNQUFBLEdBQVE7O0lBQ0ssc0JBQUMsT0FBRDtNQUNULElBQUMsQ0FBQSxVQUFELENBQVksT0FBTyxDQUFDLElBQXBCLEVBQTBCLE9BQU8sQ0FBQyxRQUFRLENBQUMsQ0FBM0MsRUFBOEMsT0FBTyxDQUFDLFFBQVEsQ0FBQyxDQUEvRDtNQUNBLElBQUMsQ0FBQSxJQUFJLENBQUMsT0FBTixDQUFjLGVBQWQ7TUFDQSxJQUFDLENBQUEsU0FBRCxHQUFhLE9BQU8sQ0FBQyxTQUFSLEdBQW9CO01BQ2pDLElBQUMsQ0FBQSxPQUFELEdBQVc7TUFDWCxJQUFDLENBQUEsUUFBRCxHQUFZO0FBQ1osY0FBTyxPQUFPLENBQUMsTUFBZjtBQUFBLGFBQ1MsU0FEVDtVQUVRLElBQUMsQ0FBQSxJQUFJLENBQUMsUUFBUSxDQUFDLENBQWYsR0FBbUIsQ0FBQyxDQUFELEdBQUssSUFBQyxDQUFBO1VBQ3pCLElBQUMsQ0FBQSxRQUFRLENBQUMsQ0FBVixJQUFlLEdBQUEsR0FBTSxPQUFPLENBQUMsU0FBUyxDQUFDO1VBQ3ZDLElBQUMsQ0FBQSxRQUFRLENBQUMsQ0FBVixJQUFlLEdBQUEsR0FBTSxPQUFPLENBQUMsU0FBUyxDQUFDO0FBSHRDO0FBRFQsYUFLUyxVQUxUO1VBTVEsSUFBQyxDQUFBLElBQUksQ0FBQyxRQUFRLENBQUMsQ0FBZixHQUFtQixDQUFBLEdBQUksSUFBQyxDQUFBO1VBQ3hCLElBQUMsQ0FBQSxRQUFRLENBQUMsQ0FBVixJQUFlLEdBQUEsR0FBTSxPQUFPLENBQUMsU0FBUyxDQUFDO1VBQ3ZDLElB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dUIsS0FBSyxDQUFDO0FBRnpDIiwic291cmNlc0NvbnRlbnQiOlsiZXhwb3J0cyA9IHRoaXNcclxuXHJcbmNsYXNzIGV4cG9ydHMuUGxheWVyQnVsbGV0IGV4dGVuZHMgVG9yY2guU3ByaXRlXHJcbiAgICBEQU1BR0U6IDFcclxuICAgIGNvbnN0cnVjdG9yOiAoc2hvb3RlcikgLT5cclxuICAgICAgICBASW5pdFNwcml0ZShzaG9vdGVyLmdhbWUsIHNob290ZXIucG9zaXRpb24ueCwgc2hvb3Rlci5wb3NpdGlvbi55KVxyXG4gICAgICAgIEBCaW5kLlRleHR1cmUoXCJwbGF5ZXItYnVsbGV0XCIpXHJcbiAgICAgICAgQGRyYXdJbmRleCA9IHNob290ZXIuZHJhd0luZGV4ICsgMVxyXG4gICAgICAgIEBzaG9vdGVyID0gc2hvb3RlclxyXG4gICAgICAgIEBWRUxPQ0lUWSA9IDEuNVxyXG4gICAgICAgIHN3aXRjaCBzaG9vdGVyLmZhY2luZ1xyXG4gICAgICAgICAgICB3aGVuIFwiZm9yd2FyZFwiXHJcbiAgICAgICAgICAgICAgICBAQm9keS52ZWxvY2l0eS55ID0gLTEgKiBAVkVMT0NJVFlcclxuICAgICAgICAgICAgICAgIEBwb3NpdGlvbi55IC09IDAuMyAqIHNob290ZXIucmVjdGFuZ2xlLmhlaWdodFxyXG4gICAgICAgICAgICAgICAgQHBvc2l0aW9uLnggKz0gMC4xICogc2hvb3Rlci5yZWN0YW5nbGUud2lkdGhcclxuICAgICAgICAgICAgd2hlbiBcImJhY2t3YXJkXCJcclxuICAgICAgICAgICAgICAgIEBCb2R5LnZlbG9jaXR5LnkgPSAxICogQFZFTE9DSVRZXHJcbiAgICAgICAgICAgICAgICBAcG9zaXRpb24ueCArPSAwLjEgKiBzaG9vdGVyLnJlY3RhbmdsZS53aWR0aFxyXG4gICAgICAgICAgICAgICAgQHBvc2l0aW9uLnkgKz0gMC4zICogc2hvb3Rlci5yZWN0YW5nbGUuaGVpZ2h0XHJcbiAgICAgICAgICAgIHdoZW4gXCJyaWdodFwiXHJcbiAgICAgICAgICAgICAgICBAQm9keS52ZWxvY2l0eS54ID0gMSAqIEBWRUxPQ0lUWVxyXG4gICAgICAgICAgICAgICAgQHBvc2l0aW9uLnggKz0gMS4xICogc2hvb3Rlci5yZWN0YW5nbGUud2lkdGhcclxuICAgICAgICAgICAgICAgIEBwb3NpdGlvbi55ICs9IDAuMjUgKiBzaG9vdGVyLnJlY3RhbmdsZS5oZWlnaHRcclxuICAgICAgICAgICAgICAgIEByb3RhdGlvbiA9IE1hdGguUEkvMlxyXG4gICAgICAgICAgICB3aGVuIFwibGVmdFwiXHJcbiAgICAgICAgICAgICAgICBAQm9keS52ZWxvY2l0eS54ID0gLTEgKiBAVkVMT0NJVFlcclxuICAgICAgICAgICAgICAgIEBwb3NpdGlvbi54IC09IDAuMSAqIHNob290ZXIucmVjdGFuZ2xlLndpZHRoXHJcbiAgICAgICAgICAgICAgICBAcG9zaXRpb24ueSArPSAwLjI1ICogc2hvb3Rlci5yZWN0YW5nbGUuaGVpZ2h0XHJcbiAgICAgICAgICAgICAgICBAcm90YXRpb24gPSBNYXRoLlBJLzJcclxuXHJcbiAgICAgICAgQFNpemUuU2NhbGUoMTAsIDEwKVxyXG5cclxuICAgICAgICBAZW1pdHRlciA9IEBnYW1lLlBhcnRpY2xlcy5QYXJ0aWNsZUVtaXR0ZXIgNTAwLCA1MDAsIDUwMCwgdHJ1ZSwgXCJzaG9vdC1wYXJ0aWNsZVwiLFxyXG4gICAgICAgICAgICBzcHJlYWQ6IDIwXHJcbiAgICAgICAgICAgIGdyYXZpdHk6IDAuMDAwMVxyXG4gICAgICAgICAgICBtaW5BbmdsZTogMFxyXG4gICAgICAgICAgICBtYXhBbmdsZTogTWF0aC5QSSAqIDJcclxuICAgICAgICAgICAgbWluU2NhbGU6IDJcclxuICAgICAgICAgICAgbWF4U2NhbGU6IDRcclxuICAgICAgICAgICAgbWluVmVsb2NpdHk6IDAuMDFcclxuICAgICAgICAgICAgbWF4VmVsb2NpdHk6IDAuMDFcclxuICAgICAgICAgICAgbWluQWxwaGFEZWNheTogMjAwXHJcbiAgICAgICAgICAgIG1heEFscGhhRGVjYXk6IDI1MFxyXG4gICAgICAgICAgICBtaW5PbWVnYTogMC4wMDFcclxuICAgICAgICAgICAgbWF4T21lZ2E6IDAuMDAxXHJcbiAgICAgICAgQGVtaXR0ZXIuYXV0byA9IGZhbHNlXHJcbiAgICAgICAgQGVtaXR0ZXIucG9zaXRpb24gPSBAcG9zaXRpb24uQ2xvbmUoKVxyXG4gICAgICAgIEBlbWl0dGVyLkVtaXRQYXJ0aWNsZXModHJ1ZSlcclxuXHJcbiAgICAgICAgQENvbGxpc2lvbnMuTW9uaXRvcigpXHJcbiAgICAgICAgQE9uIFwiQ29sbGlzaW9uXCIsIChldmVudCkgPT5cclxuICAgICAgICAgICAgcmV0dXJuIGlmIG5vdCBldmVudC5jb2xsaXNpb25EYXRhLmNvbGxpZGVyLmhhcmRCbG9ja1xyXG5cclxuICAgICAgICAgICAgZXZlbnQuY29sbGlzaW9uRGF0YS5jb2xsaWRlci5CdWxsZXRIaXQoQClcclxuXHJcbiAgICAgICAgICAgIEBUcmFzaCgpXHJcblxyXG4gICAgICAgICAgICBAZW1pdHRlci5wYXJ0aWNsZSA9IFwicGFydGljbGVcIlxyXG4gICAgICAgICAgICBAZW1pdHRlci5wb3NpdGlvbiA9IEBwb3NpdGlvbi5DbG9uZSgpXHJcbiAgICAgICAgICAgIEBlbWl0dGVyLkVtaXRQYXJ0aWNsZXModHJ1ZSlcclxuICAgICAgICAgICAgQHNob290ZXIuYXVkaW9QbGF5ZXIuUGxheVNvdW5kKFwic2hvb3QtZXhwbG9kZVwiKVxyXG5cclxuXHJcbiAgICBVcGRhdGU6IC0+XHJcbiAgICAgICAgc3VwZXIoKVxyXG4gICAgICAgIGlmIEBCb2R5LmRpc3RhbmNlID49IDUwMFxyXG4gICAgICAgICAgICBAVHJhc2goKVxyXG4iXX0=
//# sourceURL=C:\dev\js\Torch.js\Games\Zeldroid\Src\Projectiles\PlayerBullet.coffee