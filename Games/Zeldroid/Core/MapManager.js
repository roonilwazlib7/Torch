// Generated by CoffeeScript 1.12.1
(function() {
  var MapManager, exports;

  exports = this;

  MapManager = (function() {
    function MapManager(game) {
      var key, piece;
      this.game = game;
      this.Parts = [];
      this.pieces = [];
      this.IdentifierMap = [];
      for (key in MapPieces) {
        piece = MapPieces[key];
        this.Parts[piece.prototype.identifier] = piece;
      }
    }

    MapManager.prototype.LoadMap = function(fileId) {
      var i, identifier, index, j, len, len1, mapString, metaData, pieces, ref, results, seg, segment, segments, segs, sp;
      mapString = this.game.File(fileId);
      sp = mapString.split("\n");
      metaData = sp[0];
      mapString = sp[1];
      segments = mapString.split(";");
      pieces = [];
      results = [];
      for (i = 0, len = segments.length; i < len; i++) {
        segment = segments[i];
        if (segment === "") {
          break;
        }
        identifier = parseInt(segment.split(",")[0], 16);
        segs = [];
        ref = segment.split(",");
        for (index = j = 0, len1 = ref.length; j < len1; index = ++j) {
          seg = ref[index];
          if (index !== 0 && seg !== "") {
            segs.push(seg);
          }
        }
        results.push(pieces.push(new this.Parts[identifier](this.game, segs)));
      }
      return results;
    };

    return MapManager;

  })();

  exports.MapManager = MapManager;

}).call(this);

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiTWFwTWFuYWdlci5qcyIsInNvdXJjZVJvb3QiOiIuLlxcLi5cXC4uIiwic291cmNlcyI6WyJHYW1lc1xcWmVsZHJvaWRcXFNyY1xcTWFwTWFuYWdlci5jb2ZmZWUiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IjtBQUFBO0FBQUEsTUFBQTs7RUFBQSxPQUFBLEdBQVU7O0VBQ0o7SUFDVyxvQkFBQyxJQUFEO0FBQ1QsVUFBQTtNQURVLElBQUMsQ0FBQSxPQUFEO01BQ1YsSUFBQyxDQUFBLEtBQUQsR0FBUztNQUNULElBQUMsQ0FBQSxNQUFELEdBQVU7TUFDVixJQUFDLENBQUEsYUFBRCxHQUFpQjtBQUVqQixXQUFBLGdCQUFBOztRQUNJLElBQUMsQ0FBQSxLQUFNLENBQUEsS0FBSyxDQUFBLFNBQUUsQ0FBQSxVQUFQLENBQVAsR0FBNEI7QUFEaEM7SUFMUzs7eUJBUWIsT0FBQSxHQUFTLFNBQUMsTUFBRDtBQUNMLFVBQUE7TUFBQSxTQUFBLEdBQVksSUFBQyxDQUFBLElBQUksQ0FBQyxJQUFOLENBQVcsTUFBWDtNQUNaLEVBQUEsR0FBSyxTQUFTLENBQUMsS0FBVixDQUFnQixJQUFoQjtNQUNMLFFBQUEsR0FBVyxFQUFHLENBQUEsQ0FBQTtNQUNkLFNBQUEsR0FBWSxFQUFHLENBQUEsQ0FBQTtNQUVmLFFBQUEsR0FBVyxTQUFTLENBQUMsS0FBVixDQUFnQixHQUFoQjtNQUVYLE1BQUEsR0FBUztBQU1UO1dBQUEsMENBQUE7O1FBQ0ksSUFBUyxPQUFBLEtBQVcsRUFBcEI7QUFBQSxnQkFBQTs7UUFDQSxVQUFBLEdBQWEsUUFBQSxDQUFTLE9BQU8sQ0FBQyxLQUFSLENBQWMsR0FBZCxDQUFtQixDQUFBLENBQUEsQ0FBNUIsRUFBZ0MsRUFBaEM7UUFDYixJQUFBLEdBQU87QUFFUDtBQUFBLGFBQUEsdURBQUE7O1VBQ0ksSUFBa0IsS0FBQSxLQUFXLENBQVgsSUFBaUIsR0FBQSxLQUFTLEVBQTVDO1lBQUEsSUFBSSxDQUFDLElBQUwsQ0FBVSxHQUFWLEVBQUE7O0FBREo7cUJBR0EsTUFBTSxDQUFDLElBQVAsQ0FBaUIsSUFBQSxJQUFDLENBQUEsS0FBTSxDQUFBLFVBQUEsQ0FBUCxDQUFtQixJQUFDLENBQUEsSUFBcEIsRUFBMEIsSUFBMUIsQ0FBakI7QUFSSjs7SUFkSzs7Ozs7O0VBd0JiLE9BQU8sQ0FBQyxVQUFSLEdBQXFCO0FBbENyQiIsInNvdXJjZXNDb250ZW50IjpbImV4cG9ydHMgPSB0aGlzXHJcbmNsYXNzIE1hcE1hbmFnZXJcclxuICAgIGNvbnN0cnVjdG9yOiAoQGdhbWUpIC0+XHJcbiAgICAgICAgQFBhcnRzID0gW11cclxuICAgICAgICBAcGllY2VzID0gW11cclxuICAgICAgICBASWRlbnRpZmllck1hcCA9IFtdXHJcblxyXG4gICAgICAgIGZvciBrZXkscGllY2Ugb2YgTWFwUGllY2VzXHJcbiAgICAgICAgICAgIEBQYXJ0c1twaWVjZTo6aWRlbnRpZmllcl0gPSBwaWVjZVxyXG5cclxuICAgIExvYWRNYXA6IChmaWxlSWQpIC0+XHJcbiAgICAgICAgbWFwU3RyaW5nID0gQGdhbWUuRmlsZShmaWxlSWQpXHJcbiAgICAgICAgc3AgPSBtYXBTdHJpbmcuc3BsaXQoXCJcXG5cIik7XHJcbiAgICAgICAgbWV0YURhdGEgPSBzcFswXTtcclxuICAgICAgICBtYXBTdHJpbmcgPSBzcFsxXTtcclxuXHJcbiAgICAgICAgc2VnbWVudHMgPSBtYXBTdHJpbmcuc3BsaXQoXCI7XCIpXHJcblxyXG4gICAgICAgIHBpZWNlcyA9IFtdXHJcblxyXG4gICAgICAgICMgZWFjaCBtYXAgc2VnbWVudCBpcyBhIGNvbW1hIHNlcGVyYXRlZCBzdHJpbmcgb2YgaGV4YWRlY2ltYWwsIGllOlxyXG4gICAgICAgICMgYywwLDEwLDExO2ksMTAsOSw4LGZmXHJcbiAgICAgICAgIyB0aGUgZmlyc3QgbnVtYmVyIGlzIHRoZSBpZGVudGlmaWVyXHJcblxyXG4gICAgICAgIGZvciBzZWdtZW50IGluIHNlZ21lbnRzXHJcbiAgICAgICAgICAgIGJyZWFrIGlmIHNlZ21lbnQgaXMgXCJcIlxyXG4gICAgICAgICAgICBpZGVudGlmaWVyID0gcGFyc2VJbnQoc2VnbWVudC5zcGxpdChcIixcIilbMF0sIDE2KVxyXG4gICAgICAgICAgICBzZWdzID0gW11cclxuXHJcbiAgICAgICAgICAgIGZvciBzZWcsaW5kZXggaW4gc2VnbWVudC5zcGxpdChcIixcIilcclxuICAgICAgICAgICAgICAgIHNlZ3MucHVzaChzZWcpIGlmIGluZGV4IGlzbnQgMCBhbmQgc2VnIGlzbnQgXCJcIlxyXG5cclxuICAgICAgICAgICAgcGllY2VzLnB1c2goIG5ldyBAUGFydHNbaWRlbnRpZmllcl0oQGdhbWUsIHNlZ3MpIClcclxuXHJcbmV4cG9ydHMuTWFwTWFuYWdlciA9IE1hcE1hbmFnZXJcclxuIl19
//# sourceURL=C:\dev\js\Torch.js\Games\Zeldroid\Src\MapManager.coffee