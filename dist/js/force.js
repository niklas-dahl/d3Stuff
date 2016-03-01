(function() {
  var fill, gradient, height, line, line1, line2, lineFunc, mousePosition, mouseX, mouseY, positionText, rect1, scaleX, svg, width;

  width = 960;

  height = 500;

  fill = d3.scale.category10();

  mouseX = mouseY = 0;

  svg = d3.select('body').append('svg').attr('width', width).attr('height', height);

  gradient = svg.append("defs").append("linearGradient").attr("id", "gradient").attr("x1", "0%").attr("y1", "0%").attr("x2", "100%").attr("y2", "100%").attr("spreadMethod", "pad");

  gradient.append("stop").attr("offset", "0%").attr("stop-color", "#0c0").attr("stop-opacity", 1);

  gradient.append("stop").attr("offset", "100%").attr("stop-color", "#c00").attr("stop-opacity", 1);

  svg.append("rect").attr("width", 100).attr("height", 100).style("fill", "url(#gradient)");

  line1 = svg.append('rect').attr('y', 0).attr('width', 1).attr('height', height).attr('fill', 'red');

  line2 = svg.append('rect').attr('y', 0).attr('height', 1).attr('width', width).attr('fill', 'red');

  rect1 = svg.append('rect').attr('x', 100).attr('y', 100).attr('width', 140).attr('height', 30).attr('fill', 'blue');

  positionText = svg.append('text').attr('x', 110).attr('y', 120).attr('fill', 'white');

  scaleX = d3.scale.linear().range([0, width]).domain([0, width]);

  line = svg.append('path').style("stroke", "url(#gradient)");

  lineFunc = d3.svg.line().x(function(d) {
    return scaleX(d[0]);
  }).y(function(d) {
    return d[1];
  }).interpolate("cardinal");

  mousePosition = [];

  svg.on('mousemove', function() {
    var pos;
    pos = d3.mouse(this);
    mouseX = pos[0];
    mouseY = pos[1];
    line1.attr('x', mouseX);
    line2.attr('y', mouseY);
    return positionText.text("Mouse: (" + mouseX + ", " + mouseY + ")");
  });

  svg.on('mousedown', function() {
    var i, item, len, newPositions, pos;
    console.log('click');
    pos = d3.mouse(this);
    svg.append('circle').attr('cx', pos[0]).attr('cy', pos[1]).attr('r', 3);
    newPositions = [];
    for (i = 0, len = mousePosition.length; i < len; i++) {
      item = mousePosition[i];
      newPositions.push(item);
    }
    if (mousePosition[mousePosition.length - 1]) {
      newPositions.push(mousePosition[mousePosition.length - 1]);
    }
    mousePosition.push(pos);
    return line.attr('d', lineFunc(newPositions)).transition().attr('d', lineFunc(mousePosition));
  });

}).call(this);

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbImZvcmNlLmNvZmZlZSJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiQUFBQTtBQUFBLE1BQUE7O0VBQUEsS0FBQSxHQUFROztFQUNSLE1BQUEsR0FBUzs7RUFDVCxJQUFBLEdBQU8sRUFBRSxDQUFDLEtBQUssQ0FBQyxVQUFULENBQUE7O0VBRVAsTUFBQSxHQUFTLE1BQUEsR0FBUzs7RUFFbEIsR0FBQSxHQUFNLEVBQUUsQ0FBQyxNQUFILENBQVUsTUFBVixDQUFpQixDQUFDLE1BQWxCLENBQXlCLEtBQXpCLENBQ0osQ0FBQyxJQURHLENBQ0UsT0FERixFQUNXLEtBRFgsQ0FFSixDQUFDLElBRkcsQ0FFRSxRQUZGLEVBRVksTUFGWjs7RUFJTixRQUFBLEdBQVcsR0FBRyxDQUFDLE1BQUosQ0FBVyxNQUFYLENBQ1QsQ0FBQyxNQURRLENBQ0QsZ0JBREMsQ0FFUCxDQUFDLElBRk0sQ0FFRCxJQUZDLEVBRUssVUFGTCxDQUdQLENBQUMsSUFITSxDQUdELElBSEMsRUFHSyxJQUhMLENBSVAsQ0FBQyxJQUpNLENBSUQsSUFKQyxFQUlLLElBSkwsQ0FLUCxDQUFDLElBTE0sQ0FLRCxJQUxDLEVBS0ssTUFMTCxDQU1QLENBQUMsSUFOTSxDQU1ELElBTkMsRUFNSyxNQU5MLENBT1AsQ0FBQyxJQVBNLENBT0QsY0FQQyxFQU9lLEtBUGY7O0VBU1gsUUFBUSxDQUFDLE1BQVQsQ0FBZ0IsTUFBaEIsQ0FDSSxDQUFDLElBREwsQ0FDVSxRQURWLEVBQ29CLElBRHBCLENBRUksQ0FBQyxJQUZMLENBRVUsWUFGVixFQUV3QixNQUZ4QixDQUdJLENBQUMsSUFITCxDQUdVLGNBSFYsRUFHMEIsQ0FIMUI7O0VBS0EsUUFBUSxDQUFDLE1BQVQsQ0FBZ0IsTUFBaEIsQ0FDSSxDQUFDLElBREwsQ0FDVSxRQURWLEVBQ29CLE1BRHBCLENBRUksQ0FBQyxJQUZMLENBRVUsWUFGVixFQUV3QixNQUZ4QixDQUdJLENBQUMsSUFITCxDQUdVLGNBSFYsRUFHMEIsQ0FIMUI7O0VBS0EsR0FBRyxDQUFDLE1BQUosQ0FBVyxNQUFYLENBQ0ksQ0FBQyxJQURMLENBQ1UsT0FEVixFQUNtQixHQURuQixDQUVJLENBQUMsSUFGTCxDQUVVLFFBRlYsRUFFb0IsR0FGcEIsQ0FHSSxDQUFDLEtBSEwsQ0FHVyxNQUhYLEVBR21CLGdCQUhuQjs7RUFLQSxLQUFBLEdBQVEsR0FBRyxDQUFDLE1BQUosQ0FBVyxNQUFYLENBQ04sQ0FBQyxJQURLLENBQ0EsR0FEQSxFQUNLLENBREwsQ0FFTixDQUFDLElBRkssQ0FFQSxPQUZBLEVBRVMsQ0FGVCxDQUdOLENBQUMsSUFISyxDQUdBLFFBSEEsRUFHVSxNQUhWLENBSU4sQ0FBQyxJQUpLLENBSUEsTUFKQSxFQUlRLEtBSlI7O0VBTVIsS0FBQSxHQUFRLEdBQUcsQ0FBQyxNQUFKLENBQVcsTUFBWCxDQUNOLENBQUMsSUFESyxDQUNBLEdBREEsRUFDSyxDQURMLENBRU4sQ0FBQyxJQUZLLENBRUEsUUFGQSxFQUVVLENBRlYsQ0FHTixDQUFDLElBSEssQ0FHQSxPQUhBLEVBR1MsS0FIVCxDQUlOLENBQUMsSUFKSyxDQUlBLE1BSkEsRUFJUSxLQUpSOztFQU1SLEtBQUEsR0FBUSxHQUFHLENBQUMsTUFBSixDQUFXLE1BQVgsQ0FDTixDQUFDLElBREssQ0FDQSxHQURBLEVBQ0ssR0FETCxDQUVOLENBQUMsSUFGSyxDQUVBLEdBRkEsRUFFSyxHQUZMLENBR04sQ0FBQyxJQUhLLENBR0EsT0FIQSxFQUdTLEdBSFQsQ0FJTixDQUFDLElBSkssQ0FJQSxRQUpBLEVBSVUsRUFKVixDQUtOLENBQUMsSUFMSyxDQUtBLE1BTEEsRUFLUSxNQUxSOztFQU9SLFlBQUEsR0FBZSxHQUFHLENBQUMsTUFBSixDQUFXLE1BQVgsQ0FDYixDQUFDLElBRFksQ0FDUCxHQURPLEVBQ0YsR0FERSxDQUViLENBQUMsSUFGWSxDQUVQLEdBRk8sRUFFRixHQUZFLENBR2IsQ0FBQyxJQUhZLENBR1AsTUFITyxFQUdDLE9BSEQ7O0VBS2YsTUFBQSxHQUFTLEVBQUUsQ0FBQyxLQUFLLENBQUMsTUFBVCxDQUFBLENBQ1AsQ0FBQyxLQURNLENBQ0EsQ0FBQyxDQUFELEVBQUksS0FBSixDQURBLENBRVAsQ0FBQyxNQUZNLENBRUMsQ0FBQyxDQUFELEVBQUksS0FBSixDQUZEOztFQUlULElBQUEsR0FBTyxHQUFHLENBQUMsTUFBSixDQUFXLE1BQVgsQ0FDTCxDQUFDLEtBREksQ0FDRSxRQURGLEVBQ1ksZ0JBRFo7O0VBR1AsUUFBQSxHQUFXLEVBQUUsQ0FBQyxHQUFHLENBQUMsSUFBUCxDQUFBLENBQ1QsQ0FBQyxDQURRLENBQ04sU0FBQyxDQUFEO1dBQU8sTUFBQSxDQUFPLENBQUUsQ0FBQSxDQUFBLENBQVQ7RUFBUCxDQURNLENBRVQsQ0FBQyxDQUZRLENBRU4sU0FBQyxDQUFEO1dBQU8sQ0FBRSxDQUFBLENBQUE7RUFBVCxDQUZNLENBR1QsQ0FBQyxXQUhRLENBR0ksVUFISjs7RUFLWCxhQUFBLEdBQWdCOztFQUVoQixHQUFHLENBQUMsRUFBSixDQUFPLFdBQVAsRUFBb0IsU0FBQTtBQUNsQixRQUFBO0lBQUEsR0FBQSxHQUFNLEVBQUUsQ0FBQyxLQUFILENBQVMsSUFBVDtJQUVOLE1BQUEsR0FBUyxHQUFJLENBQUEsQ0FBQTtJQUNiLE1BQUEsR0FBUyxHQUFJLENBQUEsQ0FBQTtJQUViLEtBQUssQ0FBQyxJQUFOLENBQVcsR0FBWCxFQUFnQixNQUFoQjtJQUNBLEtBQUssQ0FBQyxJQUFOLENBQVcsR0FBWCxFQUFnQixNQUFoQjtXQUVBLFlBQVksQ0FBQyxJQUFiLENBQWtCLFVBQUEsR0FBVyxNQUFYLEdBQWtCLElBQWxCLEdBQXNCLE1BQXRCLEdBQTZCLEdBQS9DO0VBVGtCLENBQXBCOztFQVdBLEdBQUcsQ0FBQyxFQUFKLENBQU8sV0FBUCxFQUFvQixTQUFBO0FBQ2xCLFFBQUE7SUFBQSxPQUFPLENBQUMsR0FBUixDQUFZLE9BQVo7SUFFQSxHQUFBLEdBQU0sRUFBRSxDQUFDLEtBQUgsQ0FBUyxJQUFUO0lBQ04sR0FBRyxDQUFDLE1BQUosQ0FBVyxRQUFYLENBQ0UsQ0FBQyxJQURILENBQ1EsSUFEUixFQUNjLEdBQUksQ0FBQSxDQUFBLENBRGxCLENBRUUsQ0FBQyxJQUZILENBRVEsSUFGUixFQUVjLEdBQUksQ0FBQSxDQUFBLENBRmxCLENBR0UsQ0FBQyxJQUhILENBR1EsR0FIUixFQUdhLENBSGI7SUFNQSxZQUFBLEdBQWU7QUFDZixTQUFBLCtDQUFBOztNQUNFLFlBQVksQ0FBQyxJQUFiLENBQWtCLElBQWxCO0FBREY7SUFHQSxJQUFHLGFBQWMsQ0FBQSxhQUFhLENBQUMsTUFBZCxHQUFxQixDQUFyQixDQUFqQjtNQUNFLFlBQVksQ0FBQyxJQUFiLENBQWtCLGFBQWMsQ0FBQSxhQUFhLENBQUMsTUFBZCxHQUFxQixDQUFyQixDQUFoQyxFQURGOztJQUVBLGFBQWEsQ0FBQyxJQUFkLENBQW1CLEdBQW5CO1dBRUEsSUFDRSxDQUFDLElBREgsQ0FDUSxHQURSLEVBQ2EsUUFBQSxDQUFTLFlBQVQsQ0FEYixDQUVFLENBQUMsVUFGSCxDQUFBLENBR0UsQ0FBQyxJQUhILENBR1EsR0FIUixFQUdhLFFBQUEsQ0FBUyxhQUFULENBSGI7RUFsQmtCLENBQXBCO0FBbkZBIiwiZmlsZSI6ImZvcmNlLmpzIiwic291cmNlUm9vdCI6Ii9zb3VyY2UvIiwic291cmNlc0NvbnRlbnQiOlsid2lkdGggPSA5NjBcclxuaGVpZ2h0ID0gNTAwXHJcbmZpbGwgPSBkMy5zY2FsZS5jYXRlZ29yeTEwKClcclxuXHJcbm1vdXNlWCA9IG1vdXNlWSA9IDBcclxuXHJcbnN2ZyA9IGQzLnNlbGVjdCgnYm9keScpLmFwcGVuZCgnc3ZnJylcclxuICAuYXR0cignd2lkdGgnLCB3aWR0aClcclxuICAuYXR0cignaGVpZ2h0JywgaGVpZ2h0KVxyXG5cclxuZ3JhZGllbnQgPSBzdmcuYXBwZW5kKFwiZGVmc1wiKVxyXG4gIC5hcHBlbmQoXCJsaW5lYXJHcmFkaWVudFwiKVxyXG4gICAgLmF0dHIoXCJpZFwiLCBcImdyYWRpZW50XCIpXHJcbiAgICAuYXR0cihcIngxXCIsIFwiMCVcIilcclxuICAgIC5hdHRyKFwieTFcIiwgXCIwJVwiKVxyXG4gICAgLmF0dHIoXCJ4MlwiLCBcIjEwMCVcIilcclxuICAgIC5hdHRyKFwieTJcIiwgXCIxMDAlXCIpXHJcbiAgICAuYXR0cihcInNwcmVhZE1ldGhvZFwiLCBcInBhZFwiKTtcclxuXHJcbmdyYWRpZW50LmFwcGVuZChcInN0b3BcIilcclxuICAgIC5hdHRyKFwib2Zmc2V0XCIsIFwiMCVcIilcclxuICAgIC5hdHRyKFwic3RvcC1jb2xvclwiLCBcIiMwYzBcIilcclxuICAgIC5hdHRyKFwic3RvcC1vcGFjaXR5XCIsIDEpO1xyXG5cclxuZ3JhZGllbnQuYXBwZW5kKFwic3RvcFwiKVxyXG4gICAgLmF0dHIoXCJvZmZzZXRcIiwgXCIxMDAlXCIpXHJcbiAgICAuYXR0cihcInN0b3AtY29sb3JcIiwgXCIjYzAwXCIpXHJcbiAgICAuYXR0cihcInN0b3Atb3BhY2l0eVwiLCAxKTtcclxuXHJcbnN2Zy5hcHBlbmQoXCJyZWN0XCIpXHJcbiAgICAuYXR0cihcIndpZHRoXCIsIDEwMClcclxuICAgIC5hdHRyKFwiaGVpZ2h0XCIsIDEwMClcclxuICAgIC5zdHlsZShcImZpbGxcIiwgXCJ1cmwoI2dyYWRpZW50KVwiKVxyXG5cclxubGluZTEgPSBzdmcuYXBwZW5kKCdyZWN0JylcclxuICAuYXR0cigneScsIDApXHJcbiAgLmF0dHIoJ3dpZHRoJywgMSlcclxuICAuYXR0cignaGVpZ2h0JywgaGVpZ2h0KVxyXG4gIC5hdHRyKCdmaWxsJywgJ3JlZCcpXHJcblxyXG5saW5lMiA9IHN2Zy5hcHBlbmQoJ3JlY3QnKVxyXG4gIC5hdHRyKCd5JywgMClcclxuICAuYXR0cignaGVpZ2h0JywgMSlcclxuICAuYXR0cignd2lkdGgnLCB3aWR0aClcclxuICAuYXR0cignZmlsbCcsICdyZWQnKVxyXG5cclxucmVjdDEgPSBzdmcuYXBwZW5kKCdyZWN0JylcclxuICAuYXR0cigneCcsIDEwMClcclxuICAuYXR0cigneScsIDEwMClcclxuICAuYXR0cignd2lkdGgnLCAxNDApXHJcbiAgLmF0dHIoJ2hlaWdodCcsIDMwKVxyXG4gIC5hdHRyKCdmaWxsJywgJ2JsdWUnKVxyXG5cclxucG9zaXRpb25UZXh0ID0gc3ZnLmFwcGVuZCgndGV4dCcpXHJcbiAgLmF0dHIoJ3gnLCAxMTApXHJcbiAgLmF0dHIoJ3knLCAxMjApXHJcbiAgLmF0dHIoJ2ZpbGwnLCAnd2hpdGUnKVxyXG5cclxuc2NhbGVYID0gZDMuc2NhbGUubGluZWFyKClcclxuICAucmFuZ2UoWzAsIHdpZHRoXSlcclxuICAuZG9tYWluKFswLCB3aWR0aF0pXHJcblxyXG5saW5lID0gc3ZnLmFwcGVuZCgncGF0aCcpXHJcbiAgLnN0eWxlKFwic3Ryb2tlXCIsIFwidXJsKCNncmFkaWVudClcIilcclxuXHJcbmxpbmVGdW5jID0gZDMuc3ZnLmxpbmUoKVxyXG4gIC54KChkKSAtPiBzY2FsZVggZFswXSlcclxuICAueSgoZCkgLT4gZFsxXSlcclxuICAuaW50ZXJwb2xhdGUoXCJjYXJkaW5hbFwiKVxyXG5cclxubW91c2VQb3NpdGlvbiA9IFtdXHJcblxyXG5zdmcub24gJ21vdXNlbW92ZScsICgpIC0+XHJcbiAgcG9zID0gZDMubW91c2UodGhpcylcclxuXHJcbiAgbW91c2VYID0gcG9zWzBdXHJcbiAgbW91c2VZID0gcG9zWzFdXHJcblxyXG4gIGxpbmUxLmF0dHIoJ3gnLCBtb3VzZVgpXHJcbiAgbGluZTIuYXR0cigneScsIG1vdXNlWSlcclxuXHJcbiAgcG9zaXRpb25UZXh0LnRleHQoXCJNb3VzZTogKCN7bW91c2VYfSwgI3ttb3VzZVl9KVwiKVxyXG5cclxuc3ZnLm9uICdtb3VzZWRvd24nLCAoKSAtPlxyXG4gIGNvbnNvbGUubG9nICdjbGljaydcclxuXHJcbiAgcG9zID0gZDMubW91c2UodGhpcylcclxuICBzdmcuYXBwZW5kKCdjaXJjbGUnKVxyXG4gICAgLmF0dHIoJ2N4JywgcG9zWzBdKVxyXG4gICAgLmF0dHIoJ2N5JywgcG9zWzFdKVxyXG4gICAgLmF0dHIoJ3InLCAzKVxyXG5cclxuICAjIGNsb25lXHJcbiAgbmV3UG9zaXRpb25zID0gW11cclxuICBmb3IgaXRlbSBpbiBtb3VzZVBvc2l0aW9uXHJcbiAgICBuZXdQb3NpdGlvbnMucHVzaChpdGVtKVxyXG5cclxuICBpZiBtb3VzZVBvc2l0aW9uW21vdXNlUG9zaXRpb24ubGVuZ3RoLTFdXHJcbiAgICBuZXdQb3NpdGlvbnMucHVzaChtb3VzZVBvc2l0aW9uW21vdXNlUG9zaXRpb24ubGVuZ3RoLTFdKVxyXG4gIG1vdXNlUG9zaXRpb24ucHVzaChwb3MpXHJcblxyXG4gIGxpbmVcclxuICAgIC5hdHRyKCdkJywgbGluZUZ1bmMobmV3UG9zaXRpb25zKSlcclxuICAgIC50cmFuc2l0aW9uKClcclxuICAgIC5hdHRyKCdkJywgbGluZUZ1bmMobW91c2VQb3NpdGlvbikpXHJcblxyXG4iXX0=