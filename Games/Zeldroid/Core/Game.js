// Generated by CoffeeScript 1.12.1
(function() {
  var Draw, Init, Load, SetUpConsoleCommands, Update, zeldroid;

  Torch.StrictErrors();

  Torch.DumpErrors();

  zeldroid = new Torch.Game("container", "fill", "fill", "Zeldroid", Torch.CANVAS);

  zeldroid.GetScale = function() {
    return zeldroid.Camera.Viewport.width / 480;
  };

  Load = function(game) {
    Player.Load(game);
    HUD.Load(game);
    MapPieces.MapPiece.Load(game);
    Enemy.Load(game);
    game.Load.Texture("Assets/Art/particle.png", "particle");
    game.Load.Texture("Assets/Art/line.png", "line");
    game.Load.File("Maps/enemy-test.map", "map-1");
    game.Load.File("package.json", "package");
    game.Load.Audio("Assets/Audio/shoot.wav", "shoot");
    game.Load.Audio("Assets/Audio/shoot-explode.wav", "shoot-explode");
    game.Load.Video("test-video.mp4", "test-video");
    return game.On("LoadProgressed", function(event) {});
  };

  Init = function(game) {
    game.Clear("#00AF11");
    game.PixelScale();
    Torch.Scale = 4;
    game.backgroundAudioPlayer = game.Audio.CreateAudioPlayer();
    game.pauseMenu = new PauseMenu(game);
    game.player = new Player(game);
    game.mapManager = new MapManager(game);
    game.hud = new HUD(game);
    game.mapManager.LoadMap("map-1");
    return SetUpConsoleCommands(game);
  };

  Draw = function(game) {};

  Update = function(game) {
    if (game.deltaTime > 1000 / 50) {
      return alert("FPS Dipped! " + game.deltaTime);
    }
  };

  zeldroid.Start({
    Load: Load,
    Update: Update,
    Draw: Draw,
    Init: Init
  });

  window.zeldroid = zeldroid;

  SetUpConsoleCommands = function(game) {
    game.debugConsole = new Torch.DebugConsole(game);
    game.debugConsole.AddCommand("SPAWN", function(tConsole, piece, x, y) {
      var p;
      p = new MapPieces[piece](game, ["0", "0"]);
      p.position.x = parseInt(x);
      p.position.y = parseInt(y);
      tConsole.game.Tweens.Tween(p, 500, Torch.Easing.Smooth).From({
        opacity: 0
      }).To({
        opacity: 1
      });
      return console.log(p);
    });
    game.debugConsole.AddCommand("UCAM", function(tConsole) {
      var camVelocity, task;
      camVelocity = 1;
      task = {
        _torch_add: "Task",
        Execute: function(game) {
          if (game.Keys.RightArrow.down) {
            game.Camera.position.x -= camVelocity * game.Loop.updateDelta;
          }
          if (game.Keys.LeftArrow.down) {
            game.Camera.position.x += camVelocity * game.Loop.updateDelta;
          }
          if (game.Keys.UpArrow.down) {
            game.Camera.position.y += camVelocity * game.Loop.updateDelta;
          }
          if (game.Keys.DownArrow.down) {
            return game.Camera.position.y -= camVelocity * game.Loop.updateDelta;
          }
        }
      };
      return game.Task(task);
    });
    game.debugConsole.AddCommand("SAY", function(tConsole, thingToSay) {
      game.hud.terminal.DisplayText(thingToSay);
      return tConsole.Output("Said: " + thingToSay);
    });
    return game.debugConsole.AddCommand("HURTPLAYER", function(tConsole, howMuch) {
      howMuch = parseInt(howMuch);
      return game.player.health -= howMuch;
    });
  };

}).call(this);

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiR2FtZS5qcyIsInNvdXJjZVJvb3QiOiIuLlxcLi5cXC4uIiwic291cmNlcyI6WyJHYW1lc1xcWmVsZHJvaWRcXFNyY1xcR2FtZS5jb2ZmZWUiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IjtBQUFBO0FBQUEsTUFBQTs7RUFBQSxLQUFLLENBQUMsWUFBTixDQUFBOztFQUNBLEtBQUssQ0FBQyxVQUFOLENBQUE7O0VBRUEsUUFBQSxHQUFlLElBQUEsS0FBSyxDQUFDLElBQU4sQ0FBVyxXQUFYLEVBQXdCLE1BQXhCLEVBQWdDLE1BQWhDLEVBQXdDLFVBQXhDLEVBQW9ELEtBQUssQ0FBQyxNQUExRDs7RUFDZixRQUFRLENBQUMsUUFBVCxHQUFvQixTQUFBO0FBQ2hCLFdBQU8sUUFBUSxDQUFDLE1BQU0sQ0FBQyxRQUFRLENBQUMsS0FBekIsR0FBaUM7RUFEeEI7O0VBSXBCLElBQUEsR0FBTyxTQUFDLElBQUQ7SUFDSCxNQUFNLENBQUMsSUFBUCxDQUFZLElBQVo7SUFDQSxHQUFHLENBQUMsSUFBSixDQUFTLElBQVQ7SUFDQSxTQUFTLENBQUMsUUFBUSxDQUFDLElBQW5CLENBQXdCLElBQXhCO0lBQ0EsS0FBSyxDQUFDLElBQU4sQ0FBVyxJQUFYO0lBRUEsSUFBSSxDQUFDLElBQUksQ0FBQyxPQUFWLENBQWtCLHlCQUFsQixFQUE2QyxVQUE3QztJQUNBLElBQUksQ0FBQyxJQUFJLENBQUMsT0FBVixDQUFrQixxQkFBbEIsRUFBeUMsTUFBekM7SUFFQSxJQUFJLENBQUMsSUFBSSxDQUFDLElBQVYsQ0FBZSxxQkFBZixFQUFzQyxPQUF0QztJQUNBLElBQUksQ0FBQyxJQUFJLENBQUMsSUFBVixDQUFlLGNBQWYsRUFBK0IsU0FBL0I7SUFDQSxJQUFJLENBQUMsSUFBSSxDQUFDLEtBQVYsQ0FBZ0Isd0JBQWhCLEVBQTBDLE9BQTFDO0lBQ0EsSUFBSSxDQUFDLElBQUksQ0FBQyxLQUFWLENBQWdCLGdDQUFoQixFQUFrRCxlQUFsRDtJQUNBLElBQUksQ0FBQyxJQUFJLENBQUMs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QUFjLElBQUksQ0FBQyxJQUFJLENBQUMsWUFEdEQ7O1VBRUEsSUFBRyxJQUFJLENBQUMsSUFBSSxDQUFDLE9BQU8sQ0FBQyxJQUFyQjtZQUNJLElBQUksQ0FBQyxNQUFNLENBQUMsUUFBUSxDQUFDLENBQXJCLElBQTBCLFdBQUEsR0FBYyxJQUFJLENBQUMsSUFBSSxDQUFDLFlBRHREOztVQUVBLElBQUcsSUFBSSxDQUFDLElBQUksQ0FBQyxTQUFTLENBQUMsSUFBdkI7bUJBQ0ksSUFBSSxDQUFDLE1BQU0sQ0FBQyxRQUFRLENBQUMsQ0FBckIsSUFBMEIsV0FBQSxHQUFjLElBQUksQ0FBQyxJQUFJLENBQUMsWUFEdEQ7O1FBUEssQ0FEVDs7YUFVSixJQUFJLENBQUMsSUFBTCxDQUFVLElBQVY7SUFiaUMsQ0FBckM7SUFlQSxJQUFJLENBQUMsWUFBWSxDQUFDLFVBQWxCLENBQTZCLEtBQTdCLEVBQW9DLFNBQUMsUUFBRCxFQUFXLFVBQVg7TUFDaEMsSUFBSSxDQUFDLEdBQUcsQ0FBQyxRQUFRLENBQUMsV0FBbEIsQ0FBOEIsVUFBOUI7YUFDQSxRQUFRLENBQUMsTUFBVCxDQUFnQixRQUFBLEdBQVMsVUFBekI7SUFGZ0MsQ0FBcEM7V0FJQSxJQUFJLENBQUMsWUFBWSxDQUFDLFVBQWxCLENBQTZCLFlBQTdCLEVBQTJDLFNBQUMsUUFBRCxFQUFXLE9BQVg7TUFDdkMsT0FBQSxHQUFVLFFBQUEsQ0FBUyxPQUFUO2FBQ1YsSUFBSSxDQUFDLE1BQU0sQ0FBQyxNQUFaLElBQXNCO0lBRmlCLENBQTNDO0VBL0JtQjtBQXREdkIiLCJzb3VyY2VzQ29udGVudCI6WyJUb3JjaC5TdHJpY3RFcnJvcnMoKVxyXG5Ub3JjaC5EdW1wRXJyb3JzKClcclxuXHJcbnplbGRyb2lkID0gbmV3IFRvcmNoLkdhbWUoXCJjb250YWluZXJcIiwgXCJmaWxsXCIsIFwiZmlsbFwiLCBcIlplbGRyb2lkXCIsIFRvcmNoLkNBTlZBUylcclxuemVsZHJvaWQuR2V0U2NhbGUgPSAtPlxyXG4gICAgcmV0dXJuIHplbGRyb2lkLkNhbWVyYS5WaWV3cG9ydC53aWR0aCAvIDQ4MFxyXG5cclxuXHJcbkxvYWQgPSAoZ2FtZSkgLT5cclxuICAgIFBsYXllci5Mb2FkKGdhbWUpXHJcbiAgICBIVUQuTG9hZChnYW1lKVxyXG4gICAgTWFwUGllY2VzLk1hcFBpZWNlLkxvYWQoZ2FtZSlcclxuICAgIEVuZW15LkxvYWQoZ2FtZSlcclxuXHJcbiAgICBnYW1lLkxvYWQuVGV4dHVyZShcIkFzc2V0cy9BcnQvcGFydGljbGUucG5nXCIsIFwicGFydGljbGVcIilcclxuICAgIGdhbWUuTG9hZC5UZXh0dXJlKFwiQXNzZXRzL0FydC9saW5lLnBuZ1wiLCBcImxpbmVcIilcclxuXHJcbiAgICBnYW1lLkxvYWQuRmlsZShcIk1hcHMvZW5lbXktdGVzdC5tYXBcIiwgXCJtYXAtMVwiKVxyXG4gICAgZ2FtZS5Mb2FkLkZpbGUoXCJwYWNrYWdlLmpzb25cIiwgXCJwYWNrYWdlXCIpXHJcbiAgICBnYW1lLkxvYWQuQXVkaW8oXCJBc3NldHMvQXVkaW8vc2hvb3Qud2F2XCIsIFwic2hvb3RcIilcclxuICAgIGdhbWUuTG9hZC5BdWRpbyhcIkFzc2V0cy9BdWRpby9zaG9vdC1leHBsb2RlLndhdlwiLCBcInNob290LWV4cGxvZGVcIilcclxuICAgIGdhbWUuTG9hZC5WaWRlbyhcInRlc3QtdmlkZW8ubXA0XCIsIFwidGVzdC12aWRlb1wiKVxyXG5cclxuICAgIGdhbWUuT24gXCJMb2FkUHJvZ3Jlc3NlZFwiLCAoZXZlbnQpIC0+XHJcbiAgICAgICAgI2NvbnNvbGUubG9nKGV2ZW50LnByb2dyZXNzKVxyXG5cclxuSW5pdCA9IChnYW1lKSAtPlxyXG4gICAgZ2FtZS5DbGVhcihcIiMwMEFGMTFcIilcclxuICAgIGdhbWUuUGl4ZWxTY2FsZSgpXHJcbiAgICBUb3JjaC5TY2FsZSA9IDRcclxuXHJcbiAgICBnYW1lLmJhY2tncm91bmRBdWRpb1BsYXllciA9IGdhbWUuQXVkaW8uQ3JlYXRlQXVkaW9QbGF5ZXIoKVxyXG4gICAgZ2FtZS5wYXVzZU1lbnUgPSBuZXcgUGF1c2VNZW51KGdhbWUpXHJcbiAgICBnYW1lLnBsYXllciA9IG5ldyBQbGF5ZXIoZ2FtZSlcclxuICAgIGdhbWUubWFwTWFuYWdlciA9IG5ldyBNYXBNYW5hZ2VyKGdhbWUpXHJcbiAgICBnYW1lLmh1ZCA9IG5ldyBIVUQoZ2FtZSlcclxuICAgIGdhbWUubWFwTWFuYWdlci5Mb2FkTWFwKFwibWFwLTFcIilcclxuICAgIFNldFVwQ29uc29sZUNvbW1hbmRzKGdhbWUpXHJcblxyXG5EcmF3ID0gKGdhbWUpLT5cclxuXHJcblVwZGF0ZSA9IChnYW1lKSAtPlxyXG4gICAgaWYgZ2FtZS5kZWx0YVRpbWUgPiAxMDAwLzUwIHRoZW4gYWxlcnQoXCJGUFMgRGlwcGVkISAje2dhbWUuZGVsdGFUaW1lfVwiKVxyXG5cclxuemVsZHJvaWQuU3RhcnRcclxuICAgIExvYWQ6IExvYWRcclxuICAgIFVwZGF0ZTogVXBkYXRlXHJcbiAgICBEcmF3OiBEcmF3XHJcbiAgICBJbml0OiBJbml0XHJcblxyXG53aW5kb3cuemVsZHJvaWQgPSB6ZWxkcm9pZFxyXG5cclxuXHJcbiMgaW5pdGlhbGl6YXRpb24uLi5cclxuU2V0VXBDb25zb2xlQ29tbWFuZHMgPSAoZ2FtZSkgLT5cclxuICAgIGdhbWUuZGVidWdDb25zb2xlID0gbmV3IFRvcmNoLkRlYnVnQ29uc29sZShnYW1lKVxyXG5cclxuICAgIGdhbWUuZGVidWdDb25zb2xlLkFkZENvbW1hbmQgXCJTUEFXTlwiLCAodENvbnNvbGUsIHBpZWNlLCB4LCB5KSAtPlxyXG4gICAgICAgIHAgPSBuZXcgTWFwUGllY2VzW3BpZWNlXShnYW1lLCBbXCIwXCIsIFwiMFwiXSlcclxuICAgICAgICBwLnBvc2l0aW9uLnggPSBwYXJzZUludCh4KVxyXG4gICAgICAgIHAucG9zaXRpb24ueSA9IHBhcnNlSW50KHkpXHJcblxyXG4gICAgICAgIHRDb25zb2xlLmdhbWUuVHdlZW5zLlR3ZWVuKHAsIDUwMCwgVG9yY2guRWFzaW5nLlNtb290aCkuRnJvbSh7b3BhY2l0eTogMH0pLlRvKHtvcGFjaXR5OiAxfSlcclxuXHJcbiAgICAgICAgY29uc29sZS5sb2cocClcclxuXHJcbiAgICBnYW1lLmRlYnVnQ29uc29sZS5BZGRDb21tYW5kIFwiVUNBTVwiLCAodENvbnNvbGUpIC0+XHJcbiAgICAgICAgY2FtVmVsb2NpdHkgPSAxXHJcbiAgICAgICAgdGFzayA9XHJcbiAgICAgICAgICAgIF90b3JjaF9hZGQ6IFwiVGFza1wiXHJcbiAgICAgICAgICAgIEV4ZWN1dGU6IChnYW1lKSAtPlxyXG4gICAgICAgICAgICAgICAgaWYgZ2FtZS5LZXlzLlJpZ2h0QXJyb3cuZG93blxyXG4gICAgICAgICAgICAgICAgICAgIGdhbWUuQ2FtZXJhLnBvc2l0aW9uLnggLT0gY2FtVmVsb2NpdHkgKiBnYW1lLkxvb3AudXBkYXRlRGVsdGFcclxuICAgICAgICAgICAgICAgIGlmIGdhbWUuS2V5cy5MZWZ0QXJyb3cuZG93blxyXG4gICAgICAgICAgICAgICAgICAgIGdhbWUuQ2FtZXJhLnBvc2l0aW9uLnggKz0gY2FtVmVsb2NpdHkgKiBnYW1lLkxvb3AudXBkYXRlRGVsdGFcclxuICAgICAgICAgICAgICAgIGlmIGdhbWUuS2V5cy5VcEFycm93LmRvd25cclxuICAgICAgICAgICAgICAgICAgICBnYW1lLkNhbWVyYS5wb3NpdGlvbi55ICs9IGNhbVZlbG9jaXR5ICogZ2FtZS5Mb29wLnVwZGF0ZURlbHRhXHJcbiAgICAgICAgICAgICAgICBpZiBnYW1lLktleXMuRG93bkFycm93LmRvd25cclxuICAgICAgICAgICAgICAgICAgICBnYW1lLkNhbWVyYS5wb3NpdGlvbi55IC09IGNhbVZlbG9jaXR5ICogZ2FtZS5Mb29wLnVwZGF0ZURlbHRhXHJcbiAgICAgICAgZ2FtZS5UYXNrKHRhc2spXHJcblxyXG4gICAgZ2FtZS5kZWJ1Z0NvbnNvbGUuQWRkQ29tbWFuZCBcIlNBWVwiLCAodENvbnNvbGUsIHRoaW5nVG9TYXkpIC0+XHJcbiAgICAgICAgZ2FtZS5odWQudGVybWluYWwuRGlzcGxheVRleHQodGhpbmdUb1NheSlcclxuICAgICAgICB0Q29uc29sZS5PdXRwdXQoXCJTYWlkOiAje3RoaW5nVG9TYXl9XCIpXHJcblxyXG4gICAgZ2FtZS5kZWJ1Z0NvbnNvbGUuQWRkQ29tbWFuZCBcIkhVUlRQTEFZRVJcIiwgKHRDb25zb2xlLCBob3dNdWNoKSAtPlxyXG4gICAgICAgIGhvd011Y2ggPSBwYXJzZUludChob3dNdWNoKVxyXG4gICAgICAgIGdhbWUucGxheWVyLmhlYWx0aCAtPSBob3dNdWNoXHJcbiJdfQ==
//# sourceURL=C:\dev\js\Torch.js\Games\Zeldroid\Src\Game.coffee