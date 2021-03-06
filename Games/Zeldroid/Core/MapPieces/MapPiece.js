// Generated by CoffeeScript 1.12.1
(function() {
  var Blob, Branch, Bumps, Bush, LightGrass, MapPiece, PlayerStart, Water, exports,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  exports = this;

  MapPiece = (function(superClass) {
    extend(MapPiece, superClass);

    MapPiece.prototype.MAPPIECE = true;

    MapPiece.prototype.identifier = 0;

    MapPiece.prototype.textureId = "";

    MapPiece.prototype.data = null;

    MapPiece.prototype.scaleWidth = 1;

    MapPiece.prototype.scaleHeight = 1;

    MapPiece.prototype.hardBlock = true;

    MapPiece.prototype.hp = 2;

    function MapPiece(game, rawData) {
      var scale;
      this.InitSprite(game, 0, 0);
      this.Bind.Texture(this.textureId);
      this.data = this.GetData(rawData, game);
      this.position.x = this.data.position.x * this.texture.image.width;
      this.position.y = this.data.position.y * this.texture.image.height;
      this.drawIndex = 10;
      scale = this.game.GetScale();
      this.Size.Scale(scale, scale);
    }

    MapPiece.Load = function(game) {
      game.Load.Texture("Assets/Art/map/bush.png", "bush");
      game.Load.Texture("Assets/Art/map/water.png", "water");
      game.Load.Texture("Assets/Art/map/branch.png", "branch");
      game.Load.Texture("Assets/Art/map/light-grass.png", "light-grass");
      return game.Load.Texture("Assets/Art/map/bumps.png", "bumps");
    };

    MapPiece.prototype.GetData = function(rawData, game) {
      var data, scale;
      scale = this.game.GetScale();
      data = {};
      data.position = {
        x: parseInt(rawData[0], 16) * scale,
        y: parseInt(rawData[1], 16) * scale
      };
      return data;
    };

    MapPiece.prototype.Update = function() {
      MapPiece.__super__.Update.call(this);
      if (this.hp <= 0) {
        return this.Die();
      }
    };

    MapPiece.prototype.BulletHit = function(bullet) {
      return this.hp -= bullet.DAMAGE;
    };

    MapPiece.prototype.Die = function() {
      this.emitter = this.game.Particles.ParticleEmitter(500, 0, 0, true, this.textureId, {
        spread: 20,
        gravity: 0.0001,
        minAngle: 0,
        maxAngle: Math.PI * 2,
        minScale: 0.1,
        maxScale: 0.5,
        minVelocity: 0.01,
        maxVelocity: 0.01,
        minAlphaDecay: 400,
        maxAlphaDecay: 450,
        minOmega: 0.001,
        maxOmega: 0.001
      });
      this.emitter.auto = false;
      this.emitter.position = this.position.Clone();
      this.Trash();
      return this.emitter.EmitParticles(true);
    };

    return MapPiece;

  })(Torch.Sprite);

  Bush = (function(superClass) {
    extend(Bush, superClass);

    function Bush() {
      return Bush.__super__.constructor.apply(this, arguments);
    }

    Bush.prototype.textureId = "bush";

    Bush.prototype.hp = 2e308;

    return Bush;

  })(MapPiece);

  PlayerStart = (function(superClass) {
    extend(PlayerStart, superClass);

    function PlayerStart() {
      return PlayerStart.__super__.constructor.apply(this, arguments);
    }

    PlayerStart.prototype.textureId = "player-start";

    return PlayerStart;

  })(MapPiece);

  Water = (function(superClass) {
    extend(Water, superClass);

    function Water() {
      return Water.__super__.constructor.apply(this, arguments);
    }

    Water.prototype.textureId = "water";

    Water.prototype.identifier = 1;

    return Water;

  })(MapPiece);

  Branch = (function(superClass) {
    extend(Branch, superClass);

    function Branch() {
      return Branch.__super__.constructor.apply(this, arguments);
    }

    Branch.prototype.textureId = "branch";

    Branch.prototype.identifier = 2;

    return Branch;

  })(MapPiece);

  LightGrass = (function(superClass) {
    extend(LightGrass, superClass);

    function LightGrass() {
      return LightGrass.__super__.constructor.apply(this, arguments);
    }

    LightGrass.prototype.hardBlock = false;

    LightGrass.prototype.textureId = "light-grass";

    LightGrass.prototype.identifier = 3;

    return LightGrass;

  })(MapPiece);

  Bumps = (function(superClass) {
    extend(Bumps, superClass);

    function Bumps() {
      return Bumps.__super__.constructor.apply(this, arguments);
    }

    Bumps.prototype.hardBlock = false;

    Bumps.prototype.textureId = "bumps";

    Bumps.prototype.identifier = 4;

    return Bumps;

  })(MapPiece);

  Blob = (function(superClass) {
    extend(Blob, superClass);

    function Blob() {
      return Blob.__super__.constructor.apply(this, arguments);
    }

    Blob.prototype.hardBlock = true;

    Blob.prototype.textureId = "blob";

    Blob.prototype.identifier = 5;

    return Blob;

  })(MapPiece);

  exports.MapPieces = {
    MapPiece: MapPiece,
    Bush: Bush,
    Water: Water,
    Branch: Branch,
    LightGrass: LightGrass,
    Bumps: Bumps
  };

}).call(this);

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiTWFwUGllY2UuanMiLCJzb3VyY2VSb290IjoiLi5cXC4uXFwuLlxcLi4iLCJzb3VyY2VzIjpbIkdhbWVzXFxaZWxkcm9pZFxcU3JjXFxNYXBQaWVjZXNcXE1hcFBpZWNlLmNvZmZlZSJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiO0FBQUE7QUFBQSxNQUFBLDRFQUFBO0lBQUE7OztFQUFBLE9BQUEsR0FBVTs7RUFDSjs7O3VCQUNGLFFBQUEsR0FBVTs7dUJBQ1YsVUFBQSxHQUFZOzt1QkFDWixTQUFBLEdBQVc7O3VCQUNYLElBQUEsR0FBTTs7dUJBQ04sVUFBQSxHQUFZOzt1QkFDWixXQUFBLEdBQWE7O3VCQUNiLFNBQUEsR0FBVzs7dUJBQ1gsRUFBQSxHQUFJOztJQUNTLGtCQUFDLElBQUQsRUFBTyxPQUFQO0FBQ1QsVUFBQTtNQUFBLElBQUMsQ0FBQSxVQUFELENBQVksSUFBWixFQUFrQixDQUFsQixFQUFxQixDQUFyQjtNQUNBLElBQUMsQ0FBQSxJQUFJLENBQUMsT0FBTixDQUFjLElBQUMsQ0FBQSxTQUFmO01BQ0EsSUFBQyxDQUFBLElBQUQsR0FBUSxJQUFDLENBQUEsT0FBRCxDQUFTLE9BQVQsRUFBa0IsSUFBbEI7TUFFUixJQUFDLENBQUEsUUFBUSxDQUFDLENBQVYsR0FBYyxJQUFDLENBQUEsSUFBSSxDQUFDLFFBQVEsQ0FBQyxDQUFmLEdBQW1CLElBQUMsQ0FBQSxPQUFPLENBQUMsS0FBSyxDQUFDO01BQ2hELElBQUMsQ0FBQSxRQUFRLENBQUMsQ0FBVixHQUFjLElBQUMsQ0FBQSxJQUFJLENBQUMsUUFBUSxDQUFDLENBQWYsR0FBbUIsSUFBQyxDQUFBLE9BQU8sQ0FBQyxLQUFLLENBQUM7TUFFaEQsSUFBQyxDQUFBLFNBQUQsR0FBYTtNQUViLEtBQUEsR0FBUSxJQUFDLENBQUEsSUFBSSxDQUFDLFFBQU4sQ0FBQTtNQUNSLElBQUMsQ0FBQSxJQUFJLENBQUMsS0FBTixDQUFZLEtBQVosRUFBa0IsS0FBbEI7SUFYUzs7SUFhYixRQUFDLENBQUEsSUFB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QixPQUFPLENBQUMsU0FBUixHQUNJO0lBQUEsUUFBQSxFQUFVLFFBQVY7SUFDQSxJQUFBLEVBQU0sSUFETjtJQUVBLEtBQUEsRUFBTyxLQUZQO0lBR0EsTUFBQSxFQUFRLE1BSFI7SUFJQSxVQUFBLEVBQVksVUFKWjtJQUtBLEtBQUEsRUFBTyxLQUxQOztBQXJHSiIsInNvdXJjZXNDb250ZW50IjpbImV4cG9ydHMgPSB0aGlzXHJcbmNsYXNzIE1hcFBpZWNlIGV4dGVuZHMgVG9yY2guU3ByaXRlXHJcbiAgICBNQVBQSUVDRTogdHJ1ZVxyXG4gICAgaWRlbnRpZmllcjogMFxyXG4gICAgdGV4dHVyZUlkOiBcIlwiXHJcbiAgICBkYXRhOiBudWxsXHJcbiAgICBzY2FsZVdpZHRoOiAxXHJcbiAgICBzY2FsZUhlaWdodDogMVxyXG4gICAgaGFyZEJsb2NrOiB0cnVlXHJcbiAgICBocDogMlxyXG4gICAgY29uc3RydWN0b3I6IChnYW1lLCByYXdEYXRhKSAtPlxyXG4gICAgICAgIEBJbml0U3ByaXRlKGdhbWUsIDAsIDAgKVxyXG4gICAgICAgIEBCaW5kLlRleHR1cmUoQHRleHR1cmVJZClcclxuICAgICAgICBAZGF0YSA9IEBHZXREYXRhKHJhd0RhdGEsIGdhbWUpXHJcblxyXG4gICAgICAgIEBwb3NpdGlvbi54ID0gQGRhdGEucG9zaXRpb24ueCAqIEB0ZXh0dXJlLmltYWdlLndpZHRoXHJcbiAgICAgICAgQHBvc2l0aW9uLnkgPSBAZGF0YS5wb3NpdGlvbi55ICogQHRleHR1cmUuaW1hZ2UuaGVpZ2h0XHJcblxyXG4gICAgICAgIEBkcmF3SW5kZXggPSAxMFxyXG5cclxuICAgICAgICBzY2FsZSA9IEBnYW1lLkdldFNjYWxlKClcclxuICAgICAgICBAU2l6ZS5TY2FsZShzY2FsZSxzY2FsZSlcclxuXHJcbiAgICBATG9hZDogKGdhbWUpIC0+XHJcbiAgICAgICAgZ2FtZS5Mb2FkLlRleHR1cmUoXCJBc3NldHMvQXJ0L21hcC9idXNoLnBuZ1wiLCBcImJ1c2hcIilcclxuICAgICAgICBnYW1lLkxvYWQuVGV4dHVyZShcIkFzc2V0cy9BcnQvbWFwL3dhdGVyLnBuZ1wiLCBcIndhdGVyXCIpXHJcbiAgICAgICAgZ2FtZS5Mb2FkLlRleHR1cmUoXCJBc3NldHMvQXJ0L21hcC9icmFuY2gucG5nXCIsIFwiYnJhbmNoXCIpXHJcbiAgICAgICAgZ2FtZS5Mb2FkLlRleHR1cmUoXCJBc3NldHMvQXJ0L21hcC9saWdodC1ncmFzcy5wbmdcIiwgXCJsaWdodC1ncmFzc1wiKVxyXG4gICAgICAgIGdhbWUuTG9hZC5UZXh0dXJlKFwiQXNzZXRzL0FydC9tYXAvYnVtcHMucG5nXCIsIFwiYnVtcHNcIilcclxuXHJcblxyXG4gICAgR2V0RGF0YTogKHJhd0RhdGEsIGdhbWUpIC0+XHJcbiAgICAgICAgc2NhbGUgPSBAZ2FtZS5HZXRTY2FsZSgpXHJcbiAgICAgICAgZGF0YSA9IHt9XHJcbiAgICAgICAgZGF0YS5wb3NpdGlvbiA9XHJcbiAgICAgICAgICAgIHg6IHBhcnNlSW50KHJhd0RhdGFbMF0sIDE2KSAqIHNjYWxlXHJcbiAgICAgICAgICAgIHk6IHBhcnNlSW50KHJhd0RhdGFbMV0sIDE2KSAqIHNjYWxlXHJcblxyXG4gICAgICAgIHJldHVybiBkYXRhXHJcblxyXG4gICAgVXBkYXRlOiAtPlxyXG4gICAgICAgIHN1cGVyKClcclxuXHJcbiAgICAgICAgaWYgQGhwIDw9IDBcclxuICAgICAgICAgICAgQERpZSgpXHJcblxyXG4gICAgQnVsbGV0SGl0OiAoYnVsbGV0KSAtPlxyXG4gICAgICAgIEBocCAtPSBidWxsZXQuREFNQUdFXHJcblxyXG4gICAgRGllOiAtPlxyXG4gICAgICAgIEBlbWl0dGVyID0gQGdhbWUuUGFydGljbGVzLlBhcnRpY2xlRW1pdHRlciA1MDAsIDAsIDAsIHRydWUsIEB0ZXh0dXJlSWQsXHJcbiAgICAgICAgICAgIHNwcmVhZDogMjBcclxuICAgICAgICAgICAgZ3Jhdml0eTogMC4wMDAxXHJcbiAgICAgICAgICAgIG1pbkFuZ2xlOiAwXHJcbiAgICAgICAgICAgIG1heEFuZ2xlOiBNYXRoLlBJICogMlxyXG4gICAgICAgICAgICBtaW5TY2FsZTogMC4xXHJcbiAgICAgICAgICAgIG1heFNjYWxlOiAwLjVcclxuICAgICAgICAgICAgbWluVmVsb2NpdHk6IDAuMDFcclxuICAgICAgICAgICAgbWF4VmVsb2NpdHk6IDAuMDFcclxuICAgICAgICAgICAgbWluQWxwaGFEZWNheTogNDAwXHJcbiAgICAgICAgICAgIG1heEFscGhhRGVjYXk6IDQ1MFxyXG4gICAgICAgICAgICBtaW5PbWVnYTogMC4wMDFcclxuICAgICAgICAgICAgbWF4T21lZ2E6IDAuMDAxXHJcbiAgICAgICAgQGVtaXR0ZXIuYXV0byA9IGZhbHNlXHJcbiAgICAgICAgQGVtaXR0ZXIucG9zaXRpb24gPSBAcG9zaXRpb24uQ2xvbmUoKVxyXG4gICAgICAgIEBUcmFzaCgpXHJcbiAgICAgICAgQGVtaXR0ZXIuRW1pdFBhcnRpY2xlcyh0cnVlKVxyXG5cclxuXHJcblxyXG5jbGFzcyBCdXNoIGV4dGVuZHMgTWFwUGllY2VcclxuICAgIHRleHR1cmVJZDogXCJidXNoXCJcclxuICAgIGhwOiBJbmZpbml0eVxyXG5cclxuY2xhc3MgUGxheWVyU3RhcnQgZXh0ZW5kcyBNYXBQaWVjZVxyXG4gICAgdGV4dHVyZUlkOiBcInBsYXllci1zdGFydFwiXHJcblxyXG5jbGFzcyBXYXRlciBleHRlbmRzIE1hcFBpZWNlXHJcbiAgICB0ZXh0dXJlSWQ6IFwid2F0ZXJcIlxyXG4gICAgaWRlbnRpZmllcjogMVxyXG5cclxuY2xhc3MgQnJhbmNoIGV4dGVuZHMgTWFwUGllY2VcclxuICAgIHRleHR1cmVJZDogXCJicmFuY2hcIlxyXG4gICAgaWRlbnRpZmllcjogMlxyXG5cclxuY2xhc3MgTGlnaHRHcmFzcyBleHRlbmRzIE1hcFBpZWNlXHJcbiAgICBoYXJkQmxvY2s6IGZhbHNlXHJcbiAgICB0ZXh0dXJlSWQ6IFwibGlnaHQtZ3Jhc3NcIlxyXG4gICAgaWRlbnRpZmllcjogM1xyXG5cclxuY2xhc3MgQnVtcHMgZXh0ZW5kcyBNYXBQaWVjZVxyXG4gICAgaGFyZEJsb2NrOiBmYWxzZVxyXG4gICAgdGV4dHVyZUlkOiBcImJ1bXBzXCJcclxuICAgIGlkZW50aWZpZXI6IDRcclxuXHJcbmNsYXNzIEJsb2IgZXh0ZW5kcyBNYXBQaWVjZVxyXG4gICAgaGFyZEJsb2NrOiB0cnVlXHJcbiAgICB0ZXh0dXJlSWQ6IFwiYmxvYlwiXHJcbiAgICBpZGVudGlmaWVyOiA1XHJcblxyXG5leHBvcnRzLk1hcFBpZWNlcyA9XHJcbiAgICBNYXBQaWVjZTogTWFwUGllY2VcclxuICAgIEJ1c2g6IEJ1c2hcclxuICAgIFdhdGVyOiBXYXRlclxyXG4gICAgQnJhbmNoOiBCcmFuY2hcclxuICAgIExpZ2h0R3Jhc3M6IExpZ2h0R3Jhc3MsXHJcbiAgICBCdW1wczogQnVtcHNcclxuIl19
//# sourceURL=C:\dev\js\Torch.js\Games\Zeldroid\Src\MapPieces\MapPiece.coffee