// Generated by CoffeeScript 1.12.1
(function() {
  var AttackState, EnterState, exports,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  exports = this;

  exports.Enemy = (function(superClass) {
    extend(Enemy, superClass);

    Enemy.prototype.ENEMY = true;

    Enemy.prototype.textureName = "enemy-default";

    Enemy.prototype.powerupGenerator = null;

    Enemy.prototype.positionTarget = null;

    Enemy.prototype.velocity = 0.2;

    Enemy.prototype.startVelocity = 0.5;

    Enemy.prototype.attackDistance = 500;

    Enemy.prototype.hp = 1;

    Enemy.prototype.points = 10;

    Enemy.prototype.damage = 10;

    function Enemy(game, x, y) {
      var dir;
      Enemy.__super__.constructor.call(this, game, x, y);
      this.Bind.Texture(this.textureName);
      this.Size.Scale(1, 1);
      dir = this.GetMothershipVector();
      dir.MultiplyScalar(this.startVelocity);
      this.rotation = -dir.angle;
      this.Body.velocity.Set(dir.x, dir.y);
      this.powerupGenerator = new PowerupGenerator(this);
      this.mode = this.States.CreateStateMachine("Mode");
      this.mode.AddState("enter", new EnterState());
      this.mode.AddState("attack", new AttackState());
      this.mode.Switch("enter");
      this.On("Damaged", (function(_this) {
        return function(event) {
          return _this.hp -= event.damage;
        };
      })(this));
    }

    Enemy.Load = function(game) {
      game.Load.Texture("Assets/Art/PNG/Enemies/enemyBlack4.png", "enemy-default");
      game.Load.Texture("Assets/Art/PNG/Enemies/enemyGreen4.png", "enemy-diver-2");
      game.Load.Texture("Assets/Art/PNG/Enemies/enemyBlack1.png", "enemy-shooter");
      return game.Load.Texture("Assets/Art/PNG/Enemies/enemyGreen1.png", "enemy-shooter-2");
    };

    Enemy.prototype.Kill = function() {
      this.game.audioPlayer.PlaySound("explosion-1");
      this.game.effectGenerator.CreateSimpleExplosion(this.position.x, this.position.y);
      this.Trash();
      if (Math.random() < 0.3) {
        return this.powerupGenerator.Generate();
      }
    };

    Enemy.prototype.Update = function() {
      Enemy.__super__.Update.call(this);
      if (this.hp <= 0) {
        this.Kill();
        return this.game.score += 10;
      }
    };

    Enemy.prototype.StageAttack = function() {
      return this.Effects.Trail();
    };

    Enemy.prototype.GetMothershipVector = function() {
      var dir;
      dir = this.position.Clone();
      dir.SubtractVector(this.game.motherShip.position);
      dir.MultiplyScalar(-1);
      dir.Normalize();
      return dir;
    };

    Enemy.prototype.GetDistanceToMotherShipCenter = function() {
      var dis, ms;
      dis = this.position.Clone();
      ms = this.game.motherShip.position.Clone();
      ms.x += this.game.motherShip.rectangle.width / 2;
      ms.y += this.game.motherShip.rectangle.height / 2;
      dis.SubtractVector(ms);
      return dis.magnitude;
    };

    return Enemy;

  })(Torch.Sprite);

  exports.DiverEnemy = (function(superClass) {
    extend(DiverEnemy, superClass);

    DiverEnemy.prototype.startVelocity = 0.2;

    DiverEnemy.prototype.attackVelocity = 0.4;

    DiverEnemy.prototype.attackDistance = 300;

    function DiverEnemy(game, x, y) {
      DiverEnemy.__super__.constructor.call(this, game, x, y);
      this.Collisions.Monitor();
      this.On("Collision", (function(_this) {
        return function(event) {
          var obj;
          obj = event.collisionData.collider;
          if (obj.MOTHERSHIP) {
            obj.Emit("Damaged", {
              damage: _this.damage
            });
            return _this.Kill();
          }
        };
      })(this));
    }

    DiverEnemy.prototype.StageAttack = function() {
      DiverEnemy.__super__.StageAttack.call(this);
      this.Body.velocity.Normalize();
      return this.Body.velocity.MultiplyScalar(this.attackVelocity);
    };

    return DiverEnemy;

  })(exports.Enemy);

  exports.ShooterEnemy = (function(superClass) {
    extend(ShooterEnemy, superClass);

    ShooterEnemy.prototype.points = 20;

    ShooterEnemy.prototype.hp = 2;

    ShooterEnemy.prototype.textureName = "enemy-shooter";

    function ShooterEnemy(game, x, y) {
      ShooterEnemy.__super__.constructor.call(this, game, x, y);
    }

    ShooterEnemy.prototype.Update = function() {
      var angle, p;
      ShooterEnemy.__super__.Update.call(this);
      p = this.position.Clone();
      p.SubtractVector(this.GetObjectToOrbit().position);
      angle = -p.angle + Math.PI / 2;
      return this.rotation = angle;
    };

    ShooterEnemy.prototype.GetObjectToOrbit = function() {
      return this.game.motherShip;
    };

    ShooterEnemy.prototype.StageAttack = function() {
      var scheduledEvent;
      this.orbit = true;
      this.Effects.Trail();
      this.Body.velocity.Set(0, 0);
      this.Body.Orbit(this.GetObjectToOrbit(), 0.001, 400);
      scheduledEvent = this.game.Timer.SetScheduledEvent(300, (function(_this) {
        return function() {
          var cordX, cordY, p, p1, rot, x, y;
          p = _this.position.Clone();
          p.SubtractVector(_this.GetObjectToOrbit().position);
          p.Normalize();
          p.MultiplyScalar(-1.5);
          rot = _this.rotation - Math.PI / 2;
          cordX = Math.cos(rot);
          cordY = Math.sin(rot);
          x = _this.position.x + ((_this.rectangle.width / 2) * cordX) + _this.rectangle.width / 2;
          y = _this.position.y + ((_this.rectangle.height / 2) * cordY) + _this.rectangle.height / 2;
          x -= cordX * _this.rectangle.width;
          y -= cordY * _this.rectangle.height;
          p1 = new ShooterEnemyProjectile(_this, {
            direction: p,
            x: x,
            y: y
          });
          p1.position.x -= p1.rectangle.width / 2;
          p1.position.y -= p1.rectangle.height / 2;
          p1.drawIndex = -1;
          return _this.game.audioPlayer.PlaySound("laser-shoot-2");
        };
      })(this));
      return this.On("Trash", function() {
        return scheduledEvent.Trash();
      });
    };

    return ShooterEnemy;

  })(exports.Enemy);

  exports.ShooterEnemy2 = (function(superClass) {
    extend(ShooterEnemy2, superClass);

    function ShooterEnemy2() {
      return ShooterEnemy2.__super__.constructor.apply(this, arguments);
    }

    ShooterEnemy2.prototype.textureName = "enemy-shooter-2";

    ShooterEnemy2.prototype.GetObjectToOrbit = function() {
      return this.game.player;
    };

    return ShooterEnemy2;

  })(ShooterEnemy);

  exports.DiverEnemy2 = (function(superClass) {
    extend(DiverEnemy2, superClass);

    function DiverEnemy2() {
      return DiverEnemy2.__super__.constructor.apply(this, arguments);
    }

    DiverEnemy2.prototype.targetObj = null;

    DiverEnemy2.prototype.attackVelocity = 0.5;

    DiverEnemy2.prototype.attackDistance = 700;

    DiverEnemy2.prototype.textureName = "enemy-diver-2";

    DiverEnemy2.prototype.StageAttack = function() {
      this.Effects.Trail();
      return this.targetObj = this.game.player;
    };

    DiverEnemy2.prototype.Update = function() {
      var dir;
      DiverEnemy2.__super__.Update.call(this);
      if (this.targetObj != null) {
        dir = this.position.Clone();
        dir.SubtractVector(this.targetObj.position);
        dir.MultiplyScalar(-1);
        dir.Normalize();
        dir.MultiplyScalar(this.attackVelocity);
        this.rotation = -dir.angle;
        return this.Body.velocity.Set(dir.x, dir.y);
      }
    };

    return DiverEnemy2;

  })(DiverEnemy);

  EnterState = (function() {
    function EnterState() {}

    EnterState.prototype.Execute = function(enemy) {
      if (enemy.GetDistanceToMotherShipCenter() <= enemy.attackDistance) {
        return this.stateMachine.Switch("attack");
      }
    };

    EnterState.prototype.Start = function(enemy) {};

    EnterState.prototype.End = function(enemy) {};

    return EnterState;

  })();

  AttackState = (function() {
    function AttackState() {}

    AttackState.prototype.Execute = function(enemy) {};

    AttackState.prototype.Start = function(enemy) {
      return enemy.StageAttack();
    };

    AttackState.prototype.End = function(enemy) {};

    return AttackState;

  })();

}).call(this);

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiRW5lbXkuanMiLCJzb3VyY2VSb290IjoiLi5cXC4uXFwuLiIsInNvdXJjZXMiOlsiR2FtZXNcXE9wZW5TcGFjZVxcU3JjXFxFbmVteS5jb2ZmZWUiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IjtBQUFBO0FBQUEsTUFBQSxnQ0FBQTtJQUFBOzs7RUFBQSxPQUFBLEdBQVU7O0VBRUosT0FBTyxDQUFDOzs7b0JBQ1YsS0FBQSxHQUFPOztvQkFDUCxXQUFBLEdBQWE7O29CQUNiLGdCQUFBLEdBQWtCOztvQkFDbEIsY0FBQSxHQUFnQjs7b0JBQ2hCLFFBQUEsR0FBVTs7b0JBQ1YsYUFBQSxHQUFlOztvQkFDZixjQUFBLEdBQWdCOztvQkFDaEIsRUFBQSxHQUFJOztvQkFDSixNQUFBLEdBQVE7O29CQUNSLE1BQUEsR0FBUTs7SUFDSyxlQUFDLElBQUQsRUFBTyxDQUFQLEVBQVUsQ0FBVjtBQUNULFVBQUE7TUFBQSx1Q0FBTyxJQUFQLEVBQWEsQ0FBYixFQUFnQixDQUFoQjtNQUVBLElBQUMsQ0FBQSxJQUFJLENBQUMsT0FBTixDQUFjLElBQUMsQ0FBQSxXQUFmO01BQ0EsSUFBQyxDQUFBLElBQUksQ0FBQyxLQUFOLENBQVksQ0FBWixFQUFjLENBQWQ7TUFFQSxHQUFBLEdBQU0sSUFBQyxDQUFBLG1CQUFELENBQUE7TUFDTixHQUFHLENBQUMsY0FBSixDQUFvQixJQUFDLENBQUEsYUFBckI7TUFDQSxJQUFDLENBQUEsUUFBRCxHQUFZLENBQUMsR0FBRyxDQUFDO01BRWpCLElBQUMsQ0FBQSxJQUFJLENBQUMsUUFBUSxDQUFDLEdBQWYsQ0FBb0IsR0FBRyxDQUFDLENBQXhCLEVBQTJCLEdBQUcsQ0FBQyxDQUEvQjtNQUVBLElBQUMsQ0FBQSxnQkFBRCxHQUF3QixJQUFBLGdCQUFBLENBQWlCLElBQWpCO01BQ3hCLElBQUMsQ0FBQSxJQUFELEdBQVEsSUFBQyxDQUFBLE1BQU0sQ0FBQyxrQkFBUixDQUEyQixNQUEzQjtNQUNSLElBQUMsQ0FBQSxJQUFJLENBQUMsUUFBTixD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QyxLQUFULENBQUE7YUFDQSxJQUFDLENBQUEsU0FBRCxHQUFhLElBQUMsQ0FBQSxJQUFJLENBQUM7SUFGVjs7MEJBSWIsTUFBQSxHQUFRLFNBQUE7QUFDSixVQUFBO01BQUEsc0NBQUE7TUFFQSxJQUFHLHNCQUFIO1FBQ0ksR0FBQSxHQUFNLElBQUMsQ0FBQSxRQUFRLENBQUMsS0FBVixDQUFBO1FBQ04sR0FBRyxDQUFDLGNBQUosQ0FBb0IsSUFBQyxDQUFBLFNBQVMsQ0FBQyxRQUEvQjtRQUNBLEdBQUcsQ0FBQyxjQUFKLENBQW1CLENBQUMsQ0FBcEI7UUFDQSxHQUFHLENBQUMsU0FBSixDQUFBO1FBQ0EsR0FBRyxDQUFDLGNBQUosQ0FBb0IsSUFBQyxDQUFBLGNBQXJCO1FBQ0EsSUFBQyxDQUFBLFFBQUQsR0FBWSxDQUFDLEdBQUcsQ0FBQztlQUVqQixJQUFDLENBQUEsSUFBSSxDQUFDLFFBQVEsQ0FBQyxHQUFmLENBQW9CLEdBQUcsQ0FBQyxDQUF4QixFQUEyQixHQUFHLENBQUMsQ0FBL0IsRUFSSjs7SUFISTs7OztLQVRzQjs7RUF1QjVCOzs7eUJBQ0YsT0FBQSxHQUFTLFNBQUMsS0FBRDtNQUNMLElBQUcsS0FBSyxDQUFDLDZCQUFOLENBQUEsQ0FBQSxJQUF5QyxLQUFLLENBQUMsY0FBbEQ7ZUFDSSxJQUFDLENBQUEsWUFBWSxDQUFDLE1BQWQsQ0FBcUIsUUFBckIsRUFESjs7SUFESzs7eUJBSVQsS0FBQSxHQUFPLFNBQUMsS0FBRCxHQUFBOzt5QkFFUCxHQUFBLEdBQUssU0FBQyxLQUFELEdBQUE7Ozs7OztFQUVIOzs7MEJBQ0YsT0FBQSxHQUFTLFNBQUMsS0FBRCxHQUFBOzswQkFFVCxLQUFBLEdBQU8sU0FBQyxLQUFEO2FBQ0gsS0FBSyxDQUFDLFdBQU4sQ0FBQTtJQURHOzswQkFHUCxHQUFBLEdBQUssU0FBQyxLQUFELEdBQUE7Ozs7O0FBdk1UIiwic291cmNlc0NvbnRlbnQiOlsiZXhwb3J0cyA9IHRoaXNcclxuXHJcbmNsYXNzIGV4cG9ydHMuRW5lbXkgZXh0ZW5kcyBUb3JjaC5TcHJpdGVcclxuICAgIEVORU1ZOiB0cnVlXHJcbiAgICB0ZXh0dXJlTmFtZTogXCJlbmVteS1kZWZhdWx0XCJcclxuICAgIHBvd2VydXBHZW5lcmF0b3I6IG51bGxcclxuICAgIHBvc2l0aW9uVGFyZ2V0OiBudWxsXHJcbiAgICB2ZWxvY2l0eTogMC4yXHJcbiAgICBzdGFydFZlbG9jaXR5OiAwLjVcclxuICAgIGF0dGFja0Rpc3RhbmNlOiA1MDBcclxuICAgIGhwOiAxXHJcbiAgICBwb2ludHM6IDEwXHJcbiAgICBkYW1hZ2U6IDEwXHJcbiAgICBjb25zdHJ1Y3RvcjogKGdhbWUsIHgsIHkpIC0+XHJcbiAgICAgICAgc3VwZXIoIGdhbWUsIHgsIHkgKVxyXG5cclxuICAgICAgICBAQmluZC5UZXh0dXJlKEB0ZXh0dXJlTmFtZSlcclxuICAgICAgICBAU2l6ZS5TY2FsZSgxLDEpXHJcblxyXG4gICAgICAgIGRpciA9IEBHZXRNb3RoZXJzaGlwVmVjdG9yKClcclxuICAgICAgICBkaXIuTXVsdGlwbHlTY2FsYXIoIEBzdGFydFZlbG9jaXR5IClcclxuICAgICAgICBAcm90YXRpb24gPSAtZGlyLmFuZ2xlXHJcblxyXG4gICAgICAgIEBCb2R5LnZlbG9jaXR5LlNldCggZGlyLngsIGRpci55IClcclxuXHJcbiAgICAgICAgQHBvd2VydXBHZW5lcmF0b3IgPSBuZXcgUG93ZXJ1cEdlbmVyYXRvcihAKVxyXG4gICAgICAgIEBtb2RlID0gQFN0YXRlcy5DcmVhdGVTdGF0ZU1hY2hpbmUoXCJNb2RlXCIpXHJcbiAgICAgICAgQG1vZGUuQWRkU3RhdGUoXCJlbnRlclwiLCBuZXcgRW50ZXJTdGF0ZSgpIClcclxuICAgICAgICBAbW9kZS5BZGRTdGF0ZShcImF0dGFja1wiLCBuZXcgQXR0YWNrU3RhdGUoKSApXHJcbiAgICAgICAgQG1vZGUuU3dpdGNoKFwiZW50ZXJcIilcclxuXHJcbiAgICAgICAgQE9uIFwiRGFtYWdlZFwiLCAoZXZlbnQpID0+XHJcbiAgICAgICAgICAgIEBocCAtPSBldmVudC5kYW1hZ2VcclxuXHJcbiAgICBATG9hZDogKGdhbWUpIC0+XHJcbiAgICAgICAgZ2FtZS5Mb2FkLlRleHR1cmUoXCJBc3NldHMvQXJ0L1BORy9FbmVtaWVzL2VuZW15QmxhY2s0LnBuZ1wiLCBcImVuZW15LWRlZmF1bHRcIilcclxuICAgICAgICBnYW1lLkxvYWQuVGV4dHVyZShcIkFzc2V0cy9BcnQvUE5HL0VuZW1pZXMvZW5lbXlHcmVlbjQucG5nXCIsIFwiZW5lbXktZGl2ZXItMlwiKVxyXG4gICAgICAgIGdhbWUuTG9hZC5UZXh0dXJlKFwiQXNzZXRzL0FydC9QTkcvRW5lbWllcy9lbmVteUJsYWNrMS5wbmdcIiwgXCJlbmVteS1zaG9vdGVyXCIpXHJcbiAgICAgICAgZ2FtZS5Mb2FkLlRleHR1cmUoXCJBc3NldHMvQXJ0L1BORy9FbmVtaWVzL2VuZW15R3JlZW4xLnBuZ1wiLCBcImVuZW15LXNob290ZXItMlwiKVxyXG5cclxuICAgIEtpbGw6IC0+XHJcbiAgICAgICAgQGdhbWUuYXVkaW9QbGF5ZXIuUGxheVNvdW5kKCBcImV4cGxvc2lvbi0xXCIgKVxyXG4gICAgICAgIEBnYW1lLmVmZmVjdEdlbmVyYXRvci5DcmVhdGVTaW1wbGVFeHBsb3Npb24oIEBwb3NpdGlvbi54LCBAcG9zaXRpb24ueSApXHJcbiAgICAgICAgQFRyYXNoKClcclxuXHJcbiAgICAgICAgaWYgTWF0aC5yYW5kb20oKSA8IDAuM1xyXG4gICAgICAgICAgICBAcG93ZXJ1cEdlbmVyYXRvci5HZW5lcmF0ZSgpXHJcblxyXG4gICAgVXBkYXRlOiAtPlxyXG4gICAgICAgIHN1cGVyKClcclxuICAgICAgICBpZiBAaHAgPD0gMFxyXG4gICAgICAgICAgICBAS2lsbCgpXHJcblxyXG4gICAgICAgICAgICBAZ2FtZS5zY29yZSArPSAxMFxyXG5cclxuICAgIFN0YWdlQXR0YWNrOiAtPlxyXG4gICAgICAgIEBFZmZlY3RzLlRyYWlsKClcclxuXHJcbiAgICBHZXRNb3RoZXJzaGlwVmVjdG9yOiAtPlxyXG4gICAgICAgIGRpciA9IEBwb3NpdGlvbi5DbG9uZSgpXHJcbiAgICAgICAgZGlyLlN1YnRyYWN0VmVjdG9yKCBAZ2FtZS5tb3RoZXJTaGlwLnBvc2l0aW9uIClcclxuICAgICAgICBkaXIuTXVsdGlwbHlTY2FsYXIoLTEpXHJcbiAgICAgICAgZGlyLk5vcm1hbGl6ZSgpXHJcblxyXG4gICAgICAgIHJldHVybiBkaXJcclxuXHJcbiAgICBHZXREaXN0YW5jZVRvTW90aGVyU2hpcENlbnRlcjogLT5cclxuICAgICAgICBkaXMgPSBAcG9zaXRpb24uQ2xvbmUoKVxyXG4gICAgICAgIG1zID0gQGdhbWUubW90aGVyU2hpcC5wb3NpdGlvbi5DbG9uZSgpXHJcblxyXG4gICAgICAgIG1zLnggKz0gQGdhbWUubW90aGVyU2hpcC5yZWN0YW5nbGUud2lkdGggLyAyXHJcbiAgICAgICAgbXMueSArPSBAZ2FtZS5tb3RoZXJTaGlwLnJlY3RhbmdsZS5oZWlnaHQgLyAyXHJcblxyXG4gICAgICAgIGRpcy5TdWJ0cmFjdFZlY3RvcihtcylcclxuXHJcbiAgICAgICAgcmV0dXJuIGRpcy5tYWduaXR1ZGVcclxuXHJcbmNsYXNzIGV4cG9ydHMuRGl2ZXJFbmVteSBleHRlbmRzIGV4cG9ydHMuRW5lbXlcclxuICAgIHN0YXJ0VmVsb2NpdHk6IDAuMlxyXG4gICAgYXR0YWNrVmVsb2NpdHk6IDAuNFxyXG4gICAgYXR0YWNrRGlzdGFuY2U6IDMwMFxyXG4gICAgY29uc3RydWN0b3I6IChnYW1lLCB4LCB5KSAtPlxyXG4gICAgICAgIHN1cGVyKCBnYW1lLCB4LCB5IClcclxuXHJcbiAgICAgICAgQENvbGxpc2lvbnMuTW9uaXRvcigpXHJcblxyXG4gICAgICAgIEBPbiBcIkNvbGxpc2lvblwiLCAoZXZlbnQpID0+XHJcbiAgICAgICAgICAgIG9iaiA9IGV2ZW50LmNvbGxpc2lvbkRhdGEuY29sbGlkZXJcclxuXHJcbiAgICAgICAgICAgIGlmIG9iai5NT1RIRVJTSElQXHJcbiAgICAgICAgICAgICAgICBvYmouRW1pdCggXCJEYW1hZ2VkXCIsIGRhbWFnZTpAZGFtYWdlIClcclxuICAgICAgICAgICAgICAgIEBLaWxsKClcclxuXHJcbiAgICBTdGFnZUF0dGFjazogLT5cclxuICAgICAgICBzdXBlcigpXHJcbiAgICAgICAgQEJvZHkudmVsb2NpdHkuTm9ybWFsaXplKClcclxuICAgICAgICBAQm9keS52ZWxvY2l0eS5NdWx0aXBseVNjYWxhciggQGF0dGFja1ZlbG9jaXR5IClcclxuXHJcbmNsYXNzIGV4cG9ydHMuU2hvb3RlckVuZW15IGV4dGVuZHMgZXhwb3J0cy5FbmVteVxyXG4gICAgcG9pbnRzOiAyMFxyXG4gICAgaHA6IDJcclxuICAgIHRleHR1cmVOYW1lOiBcImVuZW15LXNob290ZXJcIlxyXG5cclxuICAgIGNvbnN0cnVjdG9yOiAoZ2FtZSwgeCwgeSkgLT5cclxuICAgICAgICBzdXBlciggZ2FtZSwgeCwgeSApXHJcblxyXG4gICAgVXBkYXRlOiAtPlxyXG4gICAgICAgIHN1cGVyKClcclxuXHJcbiAgICAgICAgIyByb2F0YXRlIGF0IHRoZSBtb3RoZXJTaGlwXHJcbiAgICAgICAgcCA9IEBwb3NpdGlvbi5DbG9uZSgpXHJcbiAgICAgICAgcC5TdWJ0cmFjdFZlY3RvciggQEdldE9iamVjdFRvT3JiaXQoKS5wb3NpdGlvbiApXHJcblxyXG4gICAgICAgIGFuZ2xlID0gLXAuYW5nbGUgKyBNYXRoLlBJLzJcclxuICAgICAgICBAcm90YXRpb24gPSBhbmdsZVxyXG5cclxuICAgIEdldE9iamVjdFRvT3JiaXQ6IC0+XHJcbiAgICAgICAgcmV0dXJuIEBnYW1lLm1vdGhlclNoaXBcclxuXHJcbiAgICBTdGFnZUF0dGFjazogLT5cclxuICAgICAgICBAb3JiaXQgPSB0cnVlXHJcbiAgICAgICAgQEVmZmVjdHMuVHJhaWwoKVxyXG4gICAgICAgIEBCb2R5LnZlbG9jaXR5LlNldCgwLDApXHJcbiAgICAgICAgQEJvZHkuT3JiaXQoIEBHZXRPYmplY3RUb09yYml0KCksIDAuMDAxLCA0MDAgKVxyXG5cclxuICAgICAgICBzY2hlZHVsZWRFdmVudCA9IEBnYW1lLlRpbWVyLlNldFNjaGVkdWxlZEV2ZW50IDMwMCwgPT5cclxuICAgICAgICAgICAgcCA9IEBwb3NpdGlvbi5DbG9uZSgpXHJcbiAgICAgICAgICAgIHAuU3VidHJhY3RWZWN0b3IoIEBHZXRPYmplY3RUb09yYml0KCkucG9zaXRpb24gKVxyXG4gICAgICAgICAgICBwLk5vcm1hbGl6ZSgpXHJcbiAgICAgICAgICAgIHAuTXVsdGlwbHlTY2FsYXIoLTEuNSlcclxuXHJcbiAgICAgICAgICAgIHJvdCA9IEByb3RhdGlvbiAtIE1hdGguUEkvMlxyXG4gICAgICAgICAgICBjb3JkWCA9IE1hdGguY29zKCByb3QgKVxyXG4gICAgICAgICAgICBjb3JkWSA9IE1hdGguc2luKCByb3QgKVxyXG5cclxuICAgICAgICAgICAgeCA9IEBwb3NpdGlvbi54ICsgKCAoQHJlY3RhbmdsZS53aWR0aCAvIDIpICogY29yZFggKSArIEByZWN0YW5nbGUud2lkdGgvMlxyXG4gICAgICAgICAgICB5ID0gQHBvc2l0aW9uLnkgKyAoIChAcmVjdGFuZ2xlLmhlaWdodCAvIDIpICogY29yZFkgKSArIEByZWN0YW5nbGUuaGVpZ2h0LzJcclxuXHJcbiAgICAgICAgICAgIHggLT0gY29yZFggKiBAcmVjdGFuZ2xlLndpZHRoXHJcbiAgICAgICAgICAgIHkgLT0gY29yZFkgKiBAcmVjdGFuZ2xlLmhlaWdodFxyXG5cclxuICAgICAgICAgICAgcDEgPSBuZXcgU2hvb3RlckVuZW15UHJvamVjdGlsZSBALFxyXG4gICAgICAgICAgICAgICAgZGlyZWN0aW9uOiBwXHJcbiAgICAgICAgICAgICAgICB4OiB4XHJcbiAgICAgICAgICAgICAgICB5OiB5XHJcblxyXG4gICAgICAgICAgICBwMS5wb3NpdGlvbi54IC09IHAxLnJlY3RhbmdsZS53aWR0aC8yXHJcbiAgICAgICAgICAgIHAxLnBvc2l0aW9uLnkgLT0gcDEucmVjdGFuZ2xlLmhlaWdodC8yXHJcblxyXG4gICAgICAgICAgICBwMS5kcmF3SW5kZXggPSAtMVxyXG5cclxuICAgICAgICAgICAgQGdhbWUuYXVkaW9QbGF5ZXIuUGxheVNvdW5kKFwibGFzZXItc2hvb3QtMlwiKVxyXG5cclxuICAgICAgICBAT24gXCJUcmFzaFwiLCAtPlxyXG4gICAgICAgICAgICBzY2hlZHVsZWRFdmVudC5UcmFzaCgpXHJcblxyXG5jbGFzcyBleHBvcnRzLlNob290ZXJFbmVteTIgZXh0ZW5kcyBTaG9vdGVyRW5lbXlcclxuICAgIHRleHR1cmVOYW1lOiBcImVuZW15LXNob290ZXItMlwiXHJcbiAgICBHZXRPYmplY3RUb09yYml0OiAtPlxyXG4gICAgICAgIHJldHVybiBAZ2FtZS5wbGF5ZXJcclxuXHJcbmNsYXNzIGV4cG9ydHMuRGl2ZXJFbmVteTIgZXh0ZW5kcyBEaXZlckVuZW15XHJcbiAgICB0YXJnZXRPYmo6IG51bGxcclxuICAgIGF0dGFja1ZlbG9jaXR5OiAwLjVcclxuICAgIGF0dGFja0Rpc3RhbmNlOiA3MDBcclxuICAgIHRleHR1cmVOYW1lOiBcImVuZW15LWRpdmVyLTJcIlxyXG4gICAgU3RhZ2VBdHRhY2s6IC0+XHJcbiAgICAgICAgQEVmZmVjdHMuVHJhaWwoKVxyXG4gICAgICAgIEB0YXJnZXRPYmogPSBAZ2FtZS5wbGF5ZXJcclxuXHJcbiAgICBVcGRhdGU6IC0+XHJcbiAgICAgICAgc3VwZXIoKVxyXG5cclxuICAgICAgICBpZiBAdGFyZ2V0T2JqP1xyXG4gICAgICAgICAgICBkaXIgPSBAcG9zaXRpb24uQ2xvbmUoKVxyXG4gICAgICAgICAgICBkaXIuU3VidHJhY3RWZWN0b3IoIEB0YXJnZXRPYmoucG9zaXRpb24gKVxyXG4gICAgICAgICAgICBkaXIuTXVsdGlwbHlTY2FsYXIoLTEpXHJcbiAgICAgICAgICAgIGRpci5Ob3JtYWxpemUoKVxyXG4gICAgICAgICAgICBkaXIuTXVsdGlwbHlTY2FsYXIoIEBhdHRhY2tWZWxvY2l0eSApXHJcbiAgICAgICAgICAgIEByb3RhdGlvbiA9IC1kaXIuYW5nbGVcclxuXHJcbiAgICAgICAgICAgIEBCb2R5LnZlbG9jaXR5LlNldCggZGlyLngsIGRpci55IClcclxuXHJcblxyXG5jbGFzcyBFbnRlclN0YXRlXHJcbiAgICBFeGVjdXRlOiAoZW5lbXkpIC0+XHJcbiAgICAgICAgaWYgZW5lbXkuR2V0RGlzdGFuY2VUb01vdGhlclNoaXBDZW50ZXIoKSA8PSBlbmVteS5hdHRhY2tEaXN0YW5jZVxyXG4gICAgICAgICAgICBAc3RhdGVNYWNoaW5lLlN3aXRjaChcImF0dGFja1wiKVxyXG5cclxuICAgIFN0YXJ0OiAoZW5lbXkpIC0+XHJcblxyXG4gICAgRW5kOiAoZW5lbXkpIC0+XHJcblxyXG5jbGFzcyBBdHRhY2tTdGF0ZVxyXG4gICAgRXhlY3V0ZTogKGVuZW15KSAtPlxyXG5cclxuICAgIFN0YXJ0OiAoZW5lbXkpIC0+XHJcbiAgICAgICAgZW5lbXkuU3RhZ2VBdHRhY2soKVxyXG5cclxuICAgIEVuZDogKGVuZW15KSAtPlxyXG4iXX0=
//# sourceURL=C:\dev\Torch\Games\OpenSpace\Src\Enemy.coffee