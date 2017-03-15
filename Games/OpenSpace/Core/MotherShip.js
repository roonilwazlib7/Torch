// Generated by CoffeeScript 1.12.1
(function() {
  var exports,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  exports = this;

  exports.MotherShip = (function(superClass) {
    extend(MotherShip, superClass);

    MotherShip.prototype.MOTHERSHIP = true;

    MotherShip.prototype.hp = 500;

    MotherShip.prototype.maxHp = 500;

    function MotherShip(game) {
      MotherShip.__super__.constructor.call(this, game, 0, 0);
      this.Body.omega = 0.0001;
      this.Bind.Texture("mothership");
      this.Size.Scale(0.5, 0.5);
      this.Center();
      this.CenterVertical();
      this.game.hud.mothershipHealth.maxCharge = this.game.hud.mothershipHealth.charge = this.hp;
      this.On("Damaged", (function(_this) {
        return function(event) {
          _this.hp -= event.damage;
          return _this.game.hud.mothershipHealth.Deplete(event.damage);
        };
      })(this));
      this.game.On("Lose", (function(_this) {
        return function() {
          return _this.Trash();
        };
      })(this));
    }

    MotherShip.Load = function(game) {
      return game.Load.Texture("Assets/Art/mothership.png", "mothership");
    };

    MotherShip.prototype.Update = function() {
      MotherShip.__super__.Update.call(this);
      if (this.hp <= 0) {
        return this.game.State.Switch("lose");
      }
    };

    return MotherShip;

  })(Torch.Sprite);

}).call(this);

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiTW90aGVyU2hpcC5qcyIsInNvdXJjZVJvb3QiOiIuLlxcLi5cXC4uIiwic291cmNlcyI6WyJHYW1lc1xcT3BlblNwYWNlXFxTcmNcXE1vdGhlclNoaXAuY29mZmVlIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7QUFBQTtBQUFBLE1BQUEsT0FBQTtJQUFBOzs7RUFBQSxPQUFBLEdBQVU7O0VBRUosT0FBTyxDQUFDOzs7eUJBQ1YsVUFBQSxHQUFZOzt5QkFDWixFQUFBLEdBQUk7O3lCQUNKLEtBQUEsR0FBTzs7SUFDTSxvQkFBQyxJQUFEO01BQ1QsNENBQU8sSUFBUCxFQUFhLENBQWIsRUFBZ0IsQ0FBaEI7TUFDQSxJQUFDLENBQUEsSUFBSSxDQUFDLEtBQU4sR0FBYztNQUNkLElBQUMsQ0FBQSxJQUFJLENBQUMsT0FBTixDQUFjLFlBQWQ7TUFDQSxJQUFDLENBQUEsSUFBSSxDQUFDLEtBQU4sQ0FBWSxHQUFaLEVBQWlCLEdBQWpCO01BQ0EsSUFBQyxDQUFBLE1BQUQsQ0FBQTtNQUNBLElBQUMsQ0FBQSxjQUFELENBQUE7TUFFQSxJQUFDLENBQUEsSUFBSSxDQUFDLEdBQUcsQ0FBQyxnQkFBZ0IsQ0FBQyxTQUEzQixHQUF1QyxJQUFDLENBQUEsSUFBSSxDQUFDLEdBQUcsQ0FBQyxnQkFBZ0IsQ0FBQyxNQUEzQixHQUFvQyxJQUFDLENBQUE7TUFFNUUsSUFBQyxDQUFBLEVBQUQsQ0FBSSxTQUFKLEVBQWUsQ0FBQSxTQUFBLEtBQUE7ZUFBQSxTQUFDLEtBQUQ7VUFDWCxLQUFDLENBQUEsRUFBRCxJQUFPLEtBQUssQ0FBQztpQkFDYixLQUFDLENBQUEsSUFBSSxDQUFDLEdBQUcsQ0FBQyxnQkFBZ0IsQ0FBQyxPQUEzQixDQUFvQyxLQUFLLENBQUMsTUFBMUM7UUFGVztNQUFBLENBQUEsQ0FBQSxDQUFBLElBQUEsQ0FBZjtNQUlBLElBQUMsQ0FBQSxJQUFJLENBQUMsRUFBTixDQUFTLE1BQVQsRUFBaUIsQ0FBQSxTQUFBLEtBQUE7ZUFBQSxTQUFBO2lCQUNiLEtBQUMsQ0FBQSxLQUFELENBQUE7UUFEYTtNQUFBLENBQUEsQ0FBQSxDQUFBLElBQUEsQ0FBakI7SUFkUzs7SUFrQmIsVUFBQyxDQUFBLElBQUQsR0FBTyxTQUFDLElBQUQ7YUFDSCxJQUFJLENBQUMsSUFBSSxDQUFDLE9BQVYsQ0FBa0IsMkJBQWxCLEVBQStDLFlBQS9DO0lBREc7O3lCQUdQLE1BQUEsR0FBUSxTQUFBO01BQ0oscUNBQUE7TUFFQSxJQUFHLElBQUMsQ0FBQSxFQUFELElBQU8sQ0FBVjtlQUNJLElBQUMsQ0FBQSxJQUFJLENBQUMsS0FBSyxDQUFDLE1BQVosQ0FBbUIsTUFBbkIsRUFESjs7SUFISTs7OztLQXpCcUIsS0FBSyxDQUFDO0FBRnZDIiwic291cmNlc0NvbnRlbnQiOlsiZXhwb3J0cyA9IHRoaXNcclxuXHJcbmNsYXNzIGV4cG9ydHMuTW90aGVyU2hpcCBleHRlbmRzIFRvcmNoLlNwcml0ZVxyXG4gICAgTU9USEVSU0hJUDogdHJ1ZVxyXG4gICAgaHA6IDUwMFxyXG4gICAgbWF4SHA6IDUwMFxyXG4gICAgY29uc3RydWN0b3I6IChnYW1lKSAtPlxyXG4gICAgICAgIHN1cGVyKCBnYW1lLCAwLCAwIClcclxuICAgICAgICBAQm9keS5vbWVnYSA9IDAuMDAwMVxyXG4gICAgICAgIEBCaW5kLlRleHR1cmUoXCJtb3RoZXJzaGlwXCIpXHJcbiAgICAgICAgQFNpemUuU2NhbGUoMC41LCAwLjUpXHJcbiAgICAgICAgQENlbnRlcigpXHJcbiAgICAgICAgQENlbnRlclZlcnRpY2FsKClcclxuXHJcbiAgICAgICAgQGdhbWUuaHVkLm1vdGhlcnNoaXBIZWFsdGgubWF4Q2hhcmdlID0gQGdhbWUuaHVkLm1vdGhlcnNoaXBIZWFsdGguY2hhcmdlID0gQGhwXHJcblxyXG4gICAgICAgIEBPbiBcIkRhbWFnZWRcIiwgKGV2ZW50KSA9PlxyXG4gICAgICAgICAgICBAaHAgLT0gZXZlbnQuZGFtYWdlXHJcbiAgICAgICAgICAgIEBnYW1lLmh1ZC5tb3RoZXJzaGlwSGVhbHRoLkRlcGxldGUoIGV2ZW50LmRhbWFnZSAgKVxyXG5cclxuICAgICAgICBAZ2FtZS5PbiBcIkxvc2VcIiwgPT5cclxuICAgICAgICAgICAgQFRyYXNoKCkgIyBtYXliZSBhbiBlZmZlY3QgaGVyZT9cclxuXHJcblxyXG4gICAgQExvYWQ6IChnYW1lKSAtPlxyXG4gICAgICAgIGdhbWUuTG9hZC5UZXh0dXJlKFwiQXNzZXRzL0FydC9tb3RoZXJzaGlwLnBuZ1wiLCBcIm1vdGhlcnNoaXBcIilcclxuXHJcbiAgICBVcGRhdGU6IC0+XHJcbiAgICAgICAgc3VwZXIoKVxyXG5cclxuICAgICAgICBpZiBAaHAgPD0gMFxyXG4gICAgICAgICAgICBAZ2FtZS5TdGF0ZS5Td2l0Y2goXCJsb3NlXCIpXHJcbiJdfQ==
//# sourceURL=C:\dev\Torch\Games\OpenSpace\Src\MotherShip.coffee