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
      angle = p.angle - Math.PI;
      return this.rotation = -angle;
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

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiRW5lbXkuanMiLCJzb3VyY2VSb290IjoiLi5cXC4uXFwuLiIsInNvdXJjZXMiOlsiR2FtZXNcXE9wZW5TcGFjZVxcU3JjXFxFbmVteS5jb2ZmZWUiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IjtBQUFBO0FBQUEsTUFBQSxnQ0FBQTtJQUFBOzs7RUFBQSxPQUFBLEdBQVU7O0VBRUosT0FBTyxDQUFDOzs7b0JBQ1YsS0FBQSxHQUFPOztvQkFDUCxXQUFBLEdBQWE7O29CQUNiLGdCQUFBLEdBQWtCOztvQkFDbEIsY0FBQSxHQUFnQjs7b0JBQ2hCLFFBQUEsR0FBVTs7b0JBQ1YsYUFBQSxHQUFlOztvQkFDZixjQUFBLEdBQWdCOztvQkFDaEIsRUFBQSxHQUFJOztvQkFDSixNQUFBLEdBQVE7O29CQUNSLE1BQUEsR0FBUTs7SUFDSyxlQUFDLElBQUQsRUFBTyxDQUFQLEVBQVUsQ0FBVjtBQUNULFVBQUE7TUFBQSx1Q0FBTyxJQUFQLEVBQWEsQ0FBYixFQUFnQixDQUFoQjtNQUVBLElBQUMsQ0FBQSxJQUFJLENBQUMsT0FBTixDQUFjLElBQUMsQ0FBQSxXQUFmO01BQ0EsSUFBQyxDQUFBLElBQUksQ0FBQyxLQUFOLENBQVksQ0FBWixFQUFjLENBQWQ7TUFFQSxHQUFBLEdBQU0sSUFBQyxDQUFBLG1CQUFELENBQUE7TUFDTixHQUFHLENBQUMsY0FBSixDQUFvQixJQUFDLENBQUEsYUFBckI7TUFDQSxJQUFDLENBQUEsUUFBRCxHQUFZLENBQUMsR0FBRyxDQUFDO01BRWpCLElBQUMsQ0FBQSxJQUFJLENBQUMsUUFBUSxDQUFDLEdBQWYsQ0FBb0IsR0FBRyxDQUFDLENBQXhCLEVBQTJCLEdBQUcsQ0FBQyxDQUEvQjtNQUVBLElBQUMsQ0FBQSxnQkFBRCxHQUF3QixJQUFBLGdCQUFBLENBQWlCLElBQWpCO01BQ3hCLElBQUMsQ0FBQSxJQUFELEdBQVEsSUFBQyxDQUFBLE1BQU0sQ0FBQyxrQkFBUixDQUEyQixNQUEzQjtNQUNSLElBQUMsQ0FBQSxJQUFJLENBQUMsUUFBTixD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QTthQUNBLElBQUMsQ0FBQSxTQUFELEdBQWEsSUFBQyxDQUFBLElBQUksQ0FBQztJQUZWOzswQkFJYixNQUFBLEdBQVEsU0FBQTtBQUNKLFVBQUE7TUFBQSxzQ0FBQTtNQUVBLElBQUcsc0JBQUg7UUFDSSxHQUFBLEdBQU0sSUFBQyxDQUFBLFFBQVEsQ0FBQyxLQUFWLENBQUE7UUFDTixHQUFHLENBQUMsY0FBSixDQUFvQixJQUFDLENBQUEsU0FBUyxDQUFDLFFBQS9CO1FBQ0EsR0FBRyxDQUFDLGNBQUosQ0FBbUIsQ0FBQyxDQUFwQjtRQUNBLEdBQUcsQ0FBQyxTQUFKLENBQUE7UUFDQSxHQUFHLENBQUMsY0FBSixDQUFvQixJQUFDLENBQUEsY0FBckI7UUFDQSxJQUFDLENBQUEsUUFBRCxHQUFZLENBQUMsR0FBRyxDQUFDO2VBRWpCLElBQUMsQ0FBQSxJQUFJLENBQUMsUUFBUSxDQUFDLEdBQWYsQ0FBb0IsR0FBRyxDQUFDLENBQXhCLEVBQTJCLEdBQUcsQ0FBQyxDQUEvQixFQVJKOztJQUhJOzs7O0tBVHNCOztFQXVCNUI7Ozt5QkFDRixPQUFBLEdBQVMsU0FBQyxLQUFEO01BQ0wsSUFBRyxLQUFLLENBQUMsNkJBQU4sQ0FBQSxDQUFBLElBQXlDLEtBQUssQ0FBQyxjQUFsRDtlQUNJLElBQUMsQ0FBQSxZQUFZLENBQUMsTUFBZCxDQUFxQixRQUFyQixFQURKOztJQURLOzt5QkFJVCxLQUFBLEdBQU8sU0FBQyxLQUFELEdBQUE7O3lCQUVQLEdBQUEsR0FBSyxTQUFDLEtBQUQsR0FBQTs7Ozs7O0VBRUg7OzswQkFDRixPQUFBLEdBQVMsU0FBQyxLQUFELEdBQUE7OzBCQUVULEtBQUEsR0FBTyxTQUFDLEtBQUQ7YUFDSCxLQUFLLENBQUMsV0FBTixDQUFBO0lBREc7OzBCQUdQLEdBQUEsR0FBSyxTQUFDLEtBQUQsR0FBQTs7Ozs7QUF2TVQiLCJzb3VyY2VzQ29udGVudCI6WyJleHBvcnRzID0gdGhpc1xyXG5cclxuY2xhc3MgZXhwb3J0cy5FbmVteSBleHRlbmRzIFRvcmNoLlNwcml0ZVxyXG4gICAgRU5FTVk6IHRydWVcclxuICAgIHRleHR1cmVOYW1lOiBcImVuZW15LWRlZmF1bHRcIlxyXG4gICAgcG93ZXJ1cEdlbmVyYXRvcjogbnVsbFxyXG4gICAgcG9zaXRpb25UYXJnZXQ6IG51bGxcclxuICAgIHZlbG9jaXR5OiAwLjJcclxuICAgIHN0YXJ0VmVsb2NpdHk6IDAuNVxyXG4gICAgYXR0YWNrRGlzdGFuY2U6IDUwMFxyXG4gICAgaHA6IDFcclxuICAgIHBvaW50czogMTBcclxuICAgIGRhbWFnZTogMTBcclxuICAgIGNvbnN0cnVjdG9yOiAoZ2FtZSwgeCwgeSkgLT5cclxuICAgICAgICBzdXBlciggZ2FtZSwgeCwgeSApXHJcblxyXG4gICAgICAgIEBCaW5kLlRleHR1cmUoQHRleHR1cmVOYW1lKVxyXG4gICAgICAgIEBTaXplLlNjYWxlKDEsMSlcclxuXHJcbiAgICAgICAgZGlyID0gQEdldE1vdGhlcnNoaXBWZWN0b3IoKVxyXG4gICAgICAgIGRpci5NdWx0aXBseVNjYWxhciggQHN0YXJ0VmVsb2NpdHkgKVxyXG4gICAgICAgIEByb3RhdGlvbiA9IC1kaXIuYW5nbGVcclxuXHJcbiAgICAgICAgQEJvZHkudmVsb2NpdHkuU2V0KCBkaXIueCwgZGlyLnkgKVxyXG5cclxuICAgICAgICBAcG93ZXJ1cEdlbmVyYXRvciA9IG5ldyBQb3dlcnVwR2VuZXJhdG9yKEApXHJcbiAgICAgICAgQG1vZGUgPSBAU3RhdGVzLkNyZWF0ZVN0YXRlTWFjaGluZShcIk1vZGVcIilcclxuICAgICAgICBAbW9kZS5BZGRTdGF0ZShcImVudGVyXCIsIG5ldyBFbnRlclN0YXRlKCkgKVxyXG4gICAgICAgIEBtb2RlLkFkZFN0YXRlKFwiYXR0YWNrXCIsIG5ldyBBdHRhY2tTdGF0ZSgpIClcclxuICAgICAgICBAbW9kZS5Td2l0Y2goXCJlbnRlclwiKVxyXG5cclxuICAgICAgICBAT24gXCJEYW1hZ2VkXCIsIChldmVudCkgPT5cclxuICAgICAgICAgICAgQGhwIC09IGV2ZW50LmRhbWFnZVxyXG5cclxuICAgIEBMb2FkOiAoZ2FtZSkgLT5cclxuICAgICAgICBnYW1lLkxvYWQuVGV4dHVyZShcIkFzc2V0cy9BcnQvUE5HL0VuZW1pZXMvZW5lbXlCbGFjazQucG5nXCIsIFwiZW5lbXktZGVmYXVsdFwiKVxyXG4gICAgICAgIGdhbWUuTG9hZC5UZXh0dXJlKFwiQXNzZXRzL0FydC9QTkcvRW5lbWllcy9lbmVteUdyZWVuNC5wbmdcIiwgXCJlbmVteS1kaXZlci0yXCIpXHJcbiAgICAgICAgZ2FtZS5Mb2FkLlRleHR1cmUoXCJBc3NldHMvQXJ0L1BORy9FbmVtaWVzL2VuZW15QmxhY2sxLnBuZ1wiLCBcImVuZW15LXNob290ZXJcIilcclxuICAgICAgICBnYW1lLkxvYWQuVGV4dHVyZShcIkFzc2V0cy9BcnQvUE5HL0VuZW1pZXMvZW5lbXlHcmVlbjEucG5nXCIsIFwiZW5lbXktc2hvb3Rlci0yXCIpXHJcblxyXG4gICAgS2lsbDogLT5cclxuICAgICAgICBAZ2FtZS5hdWRpb1BsYXllci5QbGF5U291bmQoIFwiZXhwbG9zaW9uLTFcIiApXHJcbiAgICAgICAgQGdhbWUuZWZmZWN0R2VuZXJhdG9yLkNyZWF0ZVNpbXBsZUV4cGxvc2lvbiggQHBvc2l0aW9uLngsIEBwb3NpdGlvbi55IClcclxuICAgICAgICBAVHJhc2goKVxyXG5cclxuICAgICAgICBpZiBNYXRoLnJhbmRvbSgpIDwgMC4zXHJcbiAgICAgICAgICAgIEBwb3dlcnVwR2VuZXJhdG9yLkdlbmVyYXRlKClcclxuXHJcbiAgICBVcGRhdGU6IC0+XHJcbiAgICAgICAgc3VwZXIoKVxyXG4gICAgICAgIGlmIEBocCA8PSAwXHJcbiAgICAgICAgICAgIEBLaWxsKClcclxuXHJcbiAgICAgICAgICAgIEBnYW1lLnNjb3JlICs9IDEwXHJcblxyXG4gICAgU3RhZ2VBdHRhY2s6IC0+XHJcbiAgICAgICAgQEVmZmVjdHMuVHJhaWwoKVxyXG5cclxuICAgIEdldE1vdGhlcnNoaXBWZWN0b3I6IC0+XHJcbiAgICAgICAgZGlyID0gQHBvc2l0aW9uLkNsb25lKClcclxuICAgICAgICBkaXIuU3VidHJhY3RWZWN0b3IoIEBnYW1lLm1vdGhlclNoaXAucG9zaXRpb24gKVxyXG4gICAgICAgIGRpci5NdWx0aXBseVNjYWxhcigtMSlcclxuICAgICAgICBkaXIuTm9ybWFsaXplKClcclxuXHJcbiAgICAgICAgcmV0dXJuIGRpclxyXG5cclxuICAgIEdldERpc3RhbmNlVG9Nb3RoZXJTaGlwQ2VudGVyOiAtPlxyXG4gICAgICAgIGRpcyA9IEBwb3NpdGlvbi5DbG9uZSgpXHJcbiAgICAgICAgbXMgPSBAZ2FtZS5tb3RoZXJTaGlwLnBvc2l0aW9uLkNsb25lKClcclxuXHJcbiAgICAgICAgbXMueCArPSBAZ2FtZS5tb3RoZXJTaGlwLnJlY3RhbmdsZS53aWR0aCAvIDJcclxuICAgICAgICBtcy55ICs9IEBnYW1lLm1vdGhlclNoaXAucmVjdGFuZ2xlLmhlaWdodCAvIDJcclxuXHJcbiAgICAgICAgZGlzLlN1YnRyYWN0VmVjdG9yKG1zKVxyXG5cclxuICAgICAgICByZXR1cm4gZGlzLm1hZ25pdHVkZVxyXG5cclxuY2xhc3MgZXhwb3J0cy5EaXZlckVuZW15IGV4dGVuZHMgZXhwb3J0cy5FbmVteVxyXG4gICAgc3RhcnRWZWxvY2l0eTogMC4yXHJcbiAgICBhdHRhY2tWZWxvY2l0eTogMC40XHJcbiAgICBhdHRhY2tEaXN0YW5jZTogMzAwXHJcbiAgICBjb25zdHJ1Y3RvcjogKGdhbWUsIHgsIHkpIC0+XHJcbiAgICAgICAgc3VwZXIoIGdhbWUsIHgsIHkgKVxyXG5cclxuICAgICAgICBAQ29sbGlzaW9ucy5Nb25pdG9yKClcclxuXHJcbiAgICAgICAgQE9uIFwiQ29sbGlzaW9uXCIsIChldmVudCkgPT5cclxuICAgICAgICAgICAgb2JqID0gZXZlbnQuY29sbGlzaW9uRGF0YS5jb2xsaWRlclxyXG5cclxuICAgICAgICAgICAgaWYgb2JqLk1PVEhFUlNISVBcclxuICAgICAgICAgICAgICAgIG9iai5FbWl0KCBcIkRhbWFnZWRcIiwgZGFtYWdlOkBkYW1hZ2UgKVxyXG4gICAgICAgICAgICAgICAgQEtpbGwoKVxyXG5cclxuICAgIFN0YWdlQXR0YWNrOiAtPlxyXG4gICAgICAgIHN1cGVyKClcclxuICAgICAgICBAQm9keS52ZWxvY2l0eS5Ob3JtYWxpemUoKVxyXG4gICAgICAgIEBCb2R5LnZlbG9jaXR5Lk11bHRpcGx5U2NhbGFyKCBAYXR0YWNrVmVsb2NpdHkgKVxyXG5cclxuY2xhc3MgZXhwb3J0cy5TaG9vdGVyRW5lbXkgZXh0ZW5kcyBleHBvcnRzLkVuZW15XHJcbiAgICBwb2ludHM6IDIwXHJcbiAgICBocDogMlxyXG4gICAgdGV4dHVyZU5hbWU6IFwiZW5lbXktc2hvb3RlclwiXHJcblxyXG4gICAgY29uc3RydWN0b3I6IChnYW1lLCB4LCB5KSAtPlxyXG4gICAgICAgIHN1cGVyKCBnYW1lLCB4LCB5IClcclxuXHJcbiAgICBVcGRhdGU6IC0+XHJcbiAgICAgICAgc3VwZXIoKVxyXG5cclxuICAgICAgICAjIHJvYXRhdGUgYXQgdGhlIG1vdGhlclNoaXBcclxuICAgICAgICBwID0gQHBvc2l0aW9uLkNsb25lKClcclxuICAgICAgICBwLlN1YnRyYWN0VmVjdG9yKCBAR2V0T2JqZWN0VG9PcmJpdCgpLnBvc2l0aW9uIClcclxuXHJcbiAgICAgICAgYW5nbGUgPSBwLmFuZ2xlIC0gTWF0aC5QSVxyXG4gICAgICAgIEByb3RhdGlvbiA9IC1hbmdsZVxyXG5cclxuICAgIEdldE9iamVjdFRvT3JiaXQ6IC0+XHJcbiAgICAgICAgcmV0dXJuIEBnYW1lLm1vdGhlclNoaXBcclxuXHJcbiAgICBTdGFnZUF0dGFjazogLT5cclxuICAgICAgICBAb3JiaXQgPSB0cnVlXHJcbiAgICAgICAgQEVmZmVjdHMuVHJhaWwoKVxyXG4gICAgICAgIEBCb2R5LnZlbG9jaXR5LlNldCgwLDApXHJcbiAgICAgICAgQEJvZHkuT3JiaXQoIEBHZXRPYmplY3RUb09yYml0KCksIDAuMDAxLCA0MDAgKVxyXG5cclxuICAgICAgICBzY2hlZHVsZWRFdmVudCA9IEBnYW1lLlRpbWVyLlNldFNjaGVkdWxlZEV2ZW50IDMwMCwgPT5cclxuICAgICAgICAgICAgcCA9IEBwb3NpdGlvbi5DbG9uZSgpXHJcbiAgICAgICAgICAgIHAuU3VidHJhY3RWZWN0b3IoIEBHZXRPYmplY3RUb09yYml0KCkucG9zaXRpb24gKVxyXG4gICAgICAgICAgICBwLk5vcm1hbGl6ZSgpXHJcbiAgICAgICAgICAgIHAuTXVsdGlwbHlTY2FsYXIoLTEuNSlcclxuXHJcbiAgICAgICAgICAgIHJvdCA9IEByb3RhdGlvbiAtIE1hdGguUEkvMlxyXG4gICAgICAgICAgICBjb3JkWCA9IE1hdGguY29zKCByb3QgKVxyXG4gICAgICAgICAgICBjb3JkWSA9IE1hdGguc2luKCByb3QgKVxyXG5cclxuICAgICAgICAgICAgeCA9IEBwb3NpdGlvbi54ICsgKCAoQHJlY3RhbmdsZS53aWR0aCAvIDIpICogY29yZFggKSArIEByZWN0YW5nbGUud2lkdGgvMlxyXG4gICAgICAgICAgICB5ID0gQHBvc2l0aW9uLnkgKyAoIChAcmVjdGFuZ2xlLmhlaWdodCAvIDIpICogY29yZFkgKSArIEByZWN0YW5nbGUuaGVpZ2h0LzJcclxuXHJcbiAgICAgICAgICAgIHggLT0gY29yZFggKiBAcmVjdGFuZ2xlLndpZHRoXHJcbiAgICAgICAgICAgIHkgLT0gY29yZFkgKiBAcmVjdGFuZ2xlLmhlaWdodFxyXG5cclxuICAgICAgICAgICAgcDEgPSBuZXcgU2hvb3RlckVuZW15UHJvamVjdGlsZSBALFxyXG4gICAgICAgICAgICAgICAgZGlyZWN0aW9uOiBwXHJcbiAgICAgICAgICAgICAgICB4OiB4XHJcbiAgICAgICAgICAgICAgICB5OiB5XHJcblxyXG4gICAgICAgICAgICBwMS5wb3NpdGlvbi54IC09IHAxLnJlY3RhbmdsZS53aWR0aC8yXHJcbiAgICAgICAgICAgIHAxLnBvc2l0aW9uLnkgLT0gcDEucmVjdGFuZ2xlLmhlaWdodC8yXHJcblxyXG4gICAgICAgICAgICBwMS5kcmF3SW5kZXggPSAtMVxyXG5cclxuICAgICAgICAgICAgQGdhbWUuYXVkaW9QbGF5ZXIuUGxheVNvdW5kKFwibGFzZXItc2hvb3QtMlwiKVxyXG5cclxuICAgICAgICBAT24gXCJUcmFzaFwiLCAtPlxyXG4gICAgICAgICAgICBzY2hlZHVsZWRFdmVudC5UcmFzaCgpXHJcblxyXG5jbGFzcyBleHBvcnRzLlNob290ZXJFbmVteTIgZXh0ZW5kcyBTaG9vdGVyRW5lbXlcclxuICAgIHRleHR1cmVOYW1lOiBcImVuZW15LXNob290ZXItMlwiXHJcbiAgICBHZXRPYmplY3RUb09yYml0OiAtPlxyXG4gICAgICAgIHJldHVybiBAZ2FtZS5wbGF5ZXJcclxuXHJcbmNsYXNzIGV4cG9ydHMuRGl2ZXJFbmVteTIgZXh0ZW5kcyBEaXZlckVuZW15XHJcbiAgICB0YXJnZXRPYmo6IG51bGxcclxuICAgIGF0dGFja1ZlbG9jaXR5OiAwLjVcclxuICAgIGF0dGFja0Rpc3RhbmNlOiA3MDBcclxuICAgIHRleHR1cmVOYW1lOiBcImVuZW15LWRpdmVyLTJcIlxyXG4gICAgU3RhZ2VBdHRhY2s6IC0+XHJcbiAgICAgICAgQEVmZmVjdHMuVHJhaWwoKVxyXG4gICAgICAgIEB0YXJnZXRPYmogPSBAZ2FtZS5wbGF5ZXJcclxuXHJcbiAgICBVcGRhdGU6IC0+XHJcbiAgICAgICAgc3VwZXIoKVxyXG5cclxuICAgICAgICBpZiBAdGFyZ2V0T2JqP1xyXG4gICAgICAgICAgICBkaXIgPSBAcG9zaXRpb24uQ2xvbmUoKVxyXG4gICAgICAgICAgICBkaXIuU3VidHJhY3RWZWN0b3IoIEB0YXJnZXRPYmoucG9zaXRpb24gKVxyXG4gICAgICAgICAgICBkaXIuTXVsdGlwbHlTY2FsYXIoLTEpXHJcbiAgICAgICAgICAgIGRpci5Ob3JtYWxpemUoKVxyXG4gICAgICAgICAgICBkaXIuTXVsdGlwbHlTY2FsYXIoIEBhdHRhY2tWZWxvY2l0eSApXHJcbiAgICAgICAgICAgIEByb3RhdGlvbiA9IC1kaXIuYW5nbGVcclxuXHJcbiAgICAgICAgICAgIEBCb2R5LnZlbG9jaXR5LlNldCggZGlyLngsIGRpci55IClcclxuXHJcblxyXG5jbGFzcyBFbnRlclN0YXRlXHJcbiAgICBFeGVjdXRlOiAoZW5lbXkpIC0+XHJcbiAgICAgICAgaWYgZW5lbXkuR2V0RGlzdGFuY2VUb01vdGhlclNoaXBDZW50ZXIoKSA8PSBlbmVteS5hdHRhY2tEaXN0YW5jZVxyXG4gICAgICAgICAgICBAc3RhdGVNYWNoaW5lLlN3aXRjaChcImF0dGFja1wiKVxyXG5cclxuICAgIFN0YXJ0OiAoZW5lbXkpIC0+XHJcblxyXG4gICAgRW5kOiAoZW5lbXkpIC0+XHJcblxyXG5jbGFzcyBBdHRhY2tTdGF0ZVxyXG4gICAgRXhlY3V0ZTogKGVuZW15KSAtPlxyXG5cclxuICAgIFN0YXJ0OiAoZW5lbXkpIC0+XHJcbiAgICAgICAgZW5lbXkuU3RhZ2VBdHRhY2soKVxyXG5cclxuICAgIEVuZDogKGVuZW15KSAtPlxyXG4iXX0=
//# sourceURL=C:\dev\Torch\Games\OpenSpace\Src\Enemy.coffee