(function() {
  var gauge, gauge2, gauge3, height, plugin, svg, width;

  plugin = {};

  plugin.addConfigurations = function(outer, obj, settings, defaults) {
    var idx, j, len, results, setting;
    results = [];
    for (idx = j = 0, len = settings.length; j < len; idx = ++j) {
      setting = settings[idx];
      obj[setting] = (function(setting) {
        return function(newVal) {
          if (arguments.length === 0) {
            return outer[setting];
          }
          outer[setting] = newVal;
          return obj;
        };
      })(setting);
      results.push(outer[setting] = defaults[idx]);
    }
    return results;
  };

  plugin.gauge = function() {
    var arcTween, gauge, settings;
    settings = {};
    arcTween = function(arc, oldVal, newVal) {
      return function(d) {
        var i;
        i = d3.interpolateNumber(oldVal, newVal);
        return function(t) {
          return arc(i(t));
        };
      };
    };
    gauge = function(arcGroup) {
      var arc, arcElm, getTickX, getTickY, j, k, outerArc, outerOuterArc, ref, ref1, results, results1, text, tickScale;
      arc = d3.svg.arc().startAngle(0.75 * 2 * Math.PI).endAngle(function(d) {
        return (0.75 * 2 * Math.PI) + (Math.min(Math.max(d, 0), 1) * Math.PI);
      }).innerRadius(85).outerRadius(110);
      outerArc = d3.svg.arc().startAngle(0.75 * 2 * Math.PI).endAngle(0.75 * 2 * Math.PI + Math.PI).innerRadius(85).outerRadius(110);
      outerOuterArc = d3.svg.arc().startAngle(0.75 * 2 * Math.PI).endAngle(0.75 * 2 * Math.PI + Math.PI).innerRadius(85).outerRadius(110);
      text = arcGroup.append('text').attr('y', -25).attr('class', 'innerText').text("" + (settings.valueFormatter(settings.value)));
      arcGroup.append('text').attr('y', 0).style('text-anchor', 'middle').style('fill', 'black').style('font-size', '1.2em').text(settings.text);
      arcGroup.append('path').attr('d', outerArc).attr('class', 'outline');
      settings.renderValue = settings.value / (settings.max - settings.min);
      arcElm = arcGroup.append('path').data([settings.renderValue]).attr('d', function(d) {
        return arc(d);
      }).attr('class', 'bar');
      getTickX = function(n, rad) {
        var deg, pos;
        pos = n / settings.segmentCount;
        deg = -Math.PI + pos * Math.PI;
        return Math.cos(deg) * rad;
      };
      getTickY = function(n, rad) {
        var deg, pos;
        pos = n / settings.segmentCount;
        deg = -Math.PI + pos * Math.PI;
        return Math.sin(deg) * rad;
      };
      arcGroup.selectAll('.ticks').data((function() {
        results = [];
        for (var j = 0, ref = settings.segmentCount; 0 <= ref ? j <= ref : j >= ref; 0 <= ref ? j++ : j--){ results.push(j); }
        return results;
      }).apply(this)).enter().append('line').attr('class', 'tick').attr('x1', function(d) {
        return getTickX(d, 110);
      }).attr('y1', function(d) {
        return getTickY(d, 110);
      }).attr('x2', function(d) {
        return getTickX(d, 85);
      }).attr('y2', function(d) {
        return getTickY(d, 85);
      });
      tickScale = d3.scale.linear().range([settings.min, settings.max]);
      arcGroup.selectAll('.ticks').data((function() {
        results1 = [];
        for (var k = 0, ref1 = settings.segmentCount; 0 <= ref1 ? k <= ref1 : k >= ref1; 0 <= ref1 ? k++ : k--){ results1.push(k); }
        return results1;
      }).apply(this)).enter().append('text').attr('class', function(d) {
        if (!d) {
          return 'first tickText';
        }
        if (d === settings.segmentCount) {
          return 'last tickText';
        }
        return 'tickText';
      }).attr('x', function(d) {
        return getTickX(d, 122);
      }).attr('y', function(d) {
        return getTickY(d, 122);
      }).text(function(d) {
        return settings.tickFormatter(tickScale(d / settings.segmentCount));
      });
      return gauge.update = function() {
        var scale;
        scale = d3.scale.linear().domain([settings.min, settings.max]).range([0, 1]);
        arcElm.transition().duration(settings.duration).ease('elastic').attrTween('d', arcTween(arc, settings.renderValue, scale(settings.value)));
        settings.renderValue = scale(settings.value);
        return text.text(settings.valueFormatter(settings.value));
      };
    };
    plugin.addConfigurations(settings, gauge, ['min', 'max', 'value', 'text', 'segmentCount', 'tickFormatter', 'valueFormatter', 'duration'], [0, 100, 50, '', 5, d3.format(".1f"), d3.format('.1f'), 1500]);
    return gauge;
  };

  console.log('gauge test 2 start');

  width = 1000;

  height = 1000;

  svg = d3.select('body').append('svg').attr('width', width).attr('height', height);

  gauge = plugin.gauge().text('performance').duration(4000).segmentCount(3);

  gauge2 = plugin.gauge().min(-10).max(40).value(10).text('load');

  gauge3 = plugin.gauge().segmentCount(100).tickFormatter(function() {
    return '';
  }).valueFormatter(d3.format('d')).min(100).max(500).value(200);

  window.gauge = gauge2;

  svg.append('g').attr('id', 'gauge1').attr('class', 'gauge').attr('transform', "translate(" + 400. + ", " + 300. + ") scale(2)").call(gauge2);

  svg.append('g').attr('class', 'gauge').attr('transform', "translate(" + 250. + ", " + 600. + ") scale(1.5)").call(gauge);

  svg.append('g').attr('class', 'gauge').attr('transform', "translate(" + 700. + ", " + 600. + ") scale(1.5)").call(gauge3);

  setInterval(function() {
    return gauge2.value(Math.random() * (gauge2.max() - gauge2.min()) + gauge2.min()).update();
  }, 3000);

  setInterval(function() {
    return gauge3.value((gauge3.value() + 1) % gauge3.max()).update();
  }, 10);

  setInterval(function() {
    return gauge.value(Math.random() * (gauge.max() - gauge.min()) + gauge.min()).update();
  }, 5000);

}).call(this);

//# sourceMappingURL=data:application/json;base64,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QWUsQ0FBaEIsQ0FBQSxHQUFxQixNQUFNLENBQUMsR0FBUCxDQUFBLENBQW5DLENBQWlELENBQUMsTUFBbEQsQ0FBQTtFQURVLENBQVosRUFFRSxFQUZGOztFQUlBLFdBQUEsQ0FBWSxTQUFBO1dBQ1YsS0FBSyxDQUFDLEtBQU4sQ0FBYyxJQUFJLENBQUMsTUFBTCxDQUFBLENBQUEsR0FBZ0IsQ0FBQyxLQUFLLENBQUMsR0FBTixDQUFBLENBQUEsR0FBWSxLQUFLLENBQUMsR0FBTixDQUFBLENBQWIsQ0FBaEIsR0FBNEMsS0FBSyxDQUFDLEdBQU4sQ0FBQSxDQUExRCxDQUF3RSxDQUFDLE1BQXpFLENBQUE7RUFEVSxDQUFaLEVBRUUsSUFGRjtBQXRMQSIsImZpbGUiOiJnYXVnZTIuanMiLCJzb3VyY2VSb290IjoiL3NvdXJjZS8iLCJzb3VyY2VzQ29udGVudCI6WyIjIHBzZXVkbyBwbHVnaW4gY29udGFpbmVyXHJcbnBsdWdpbiA9IHt9XHJcblxyXG4jIGhlbHBlciBmdW5jdGlvbiBmb3Igc2V0dGluZ3NcclxucGx1Z2luLmFkZENvbmZpZ3VyYXRpb25zID0gKG91dGVyLCBvYmosIHNldHRpbmdzLCBkZWZhdWx0cykgLT5cclxuICBmb3Igc2V0dGluZywgaWR4IGluIHNldHRpbmdzXHJcbiAgICBcclxuICAgIG9ialtzZXR0aW5nXSA9ICgoc2V0dGluZykgLT5cclxuICAgICAgKG5ld1ZhbCkgLT5cclxuICAgICAgICBpZiBhcmd1bWVudHMubGVuZ3RoID09IDBcclxuICAgICAgICAgIHJldHVybiBvdXRlcltzZXR0aW5nXVxyXG4gICAgICAgIG91dGVyW3NldHRpbmddID0gbmV3VmFsXHJcbiAgICAgICAgb2JqXHJcbiAgICApKHNldHRpbmcpXHJcblxyXG4gICAgb3V0ZXJbc2V0dGluZ10gPSBkZWZhdWx0c1tpZHhdXHJcblxyXG4jIGFkZCB0aGUgZ2F1Z2UgcGx1Z2luXHJcbnBsdWdpbi5nYXVnZSA9ICgpIC0+XHJcbiAgc2V0dGluZ3MgPSB7fVxyXG5cclxuICAjIGFyYyBpbnRlcnBvbGF0b3JcclxuICBhcmNUd2VlbiA9IChhcmMsIG9sZFZhbCwgbmV3VmFsKSAtPlxyXG4gICAgcmV0dXJuIChkKSAtPlxyXG4gICAgICBpID0gZDMuaW50ZXJwb2xhdGVOdW1iZXIob2xkVmFsLCBuZXdWYWwpXHJcbiAgICAgIHJldHVybiAodCkgLT5cclxuICAgICAgICByZXR1cm4gYXJjKGkodCkpXHJcblxyXG4gICMgcmV0dXJuZWQgZ2VuZXJhdG9yIGZ1bmN0aW9uXHJcbiAgZ2F1Z2UgPSAoYXJjR3JvdXApIC0+XHJcbiAgICBhcmMgPSBkMy5zdmcuYXJjKClcclxuICAgICAgLnN0YXJ0QW5nbGUoMC43NSAqIDIgKiBNYXRoLlBJKVxyXG4gICAgICAuZW5kQW5nbGUoKGQpIC0+ICgwLjc1ICogMiAqIE1hdGguUEkpICsgKE1hdGgubWluKE1hdGgubWF4KGQsIDApLCAxKSAqIE1hdGguUEkpKVxyXG4gICAgICAuaW5uZXJSYWRpdXMoODUpXHJcbiAgICAgIC5vdXRlclJhZGl1cygxMTApXHJcblxyXG4gICAgb3V0ZXJBcmMgPSBkMy5zdmcuYXJjKClcclxuICAgICAgLnN0YXJ0QW5nbGUoMC43NSAqIDIgKiBNYXRoLlBJKVxyXG4gICAgICAuZW5kQW5nbGUoMC43NSAqIDIgKiBNYXRoLlBJICsgTWF0aC5QSSlcclxuICAgICAgLmlubmVyUmFkaXVzKDg1KVxyXG4gICAgICAub3V0ZXJSYWRpdXMoMTEwKVxyXG5cclxuICAgIG91dGVyT3V0ZXJBcmMgPSBkMy5zdmcuYXJjKClcclxuICAgICAgLnN0YXJ0QW5nbGUoMC43NSAqIDIgKiBNYXRoLlBJKVxyXG4gICAgICAuZW5kQW5nbGUoMC43NSAqIDIgKiBNYXRoLlBJICsgTWF0aC5QSSlcclxuICAgICAgLmlubmVyUmFkaXVzKDg1KVxyXG4gICAgICAub3V0ZXJSYWRpdXMoMTEwKVxyXG5cclxuICAgICMgY2VudGVyIHRleHRcclxuICAgIHRleHQgPSBhcmNHcm91cC5hcHBlbmQoJ3RleHQnKVxyXG4gICAgICAuYXR0cigneScsIC0yNSlcclxuICAgICAgLmF0dHIoJ2NsYXNzJywgJ2lubmVyVGV4dCcpXHJcbiAgICAgIC50ZXh0KFwiI3tzZXR0aW5ncy52YWx1ZUZvcm1hdHRlcihzZXR0aW5ncy52YWx1ZSl9XCIpXHJcblxyXG4gICAgIyBib3R0dW0gdGV4dFxyXG4gICAgYXJjR3JvdXAuYXBwZW5kKCd0ZXh0JylcclxuICAgICAgLmF0dHIoJ3knLCAwKVxyXG4gICAgICAuc3R5bGUoJ3RleHQtYW5jaG9yJywgJ21pZGRsZScpXHJcbiAgICAgIC5zdHlsZSgnZmlsbCcsICdibGFjaycpXHJcbiAgICAgIC5zdHlsZSgnZm9udC1zaXplJywgJzEuMmVtJylcclxuICAgICAgLnRleHQoc2V0dGluZ3MudGV4dClcclxuXHJcbiAgICAjIGJhY2tncm91bmQgYXJjXHJcbiAgICBhcmNHcm91cC5hcHBlbmQoJ3BhdGgnKVxyXG4gICAgICAuYXR0cignZCcsIG91dGVyQXJjKVxyXG4gICAgICAuYXR0cignY2xhc3MnLCAnb3V0bGluZScpXHJcblxyXG4gICAgIyBhY3R1YWwgYXJjXHJcbiAgICBzZXR0aW5ncy5yZW5kZXJWYWx1ZSA9IHNldHRpbmdzLnZhbHVlIC8gKHNldHRpbmdzLm1heC1zZXR0aW5ncy5taW4pXHJcbiAgICBhcmNFbG0gPSBhcmNHcm91cC5hcHBlbmQoJ3BhdGgnKS5kYXRhKFtzZXR0aW5ncy5yZW5kZXJWYWx1ZV0pXHJcbiAgICAgIC5hdHRyKCdkJywgKGQpIC0+IGFyYyhkKSlcclxuICAgICAgLmF0dHIoJ2NsYXNzJywgJ2JhcicpXHJcblxyXG4gICAgIyB0aWNrc1xyXG4gICAgZ2V0VGlja1ggID0gKG4sIHJhZCkgLT5cclxuICAgICAgcG9zID0gbiAvIHNldHRpbmdzLnNlZ21lbnRDb3VudFxyXG4gICAgICBkZWcgPSAtTWF0aC5QSSArIHBvcyAqIE1hdGguUElcclxuICAgICAgTWF0aC5jb3MoZGVnKSAqIHJhZFxyXG4gICAgXHJcbiAgICBnZXRUaWNrWSAgPSAobiwgcmFkKSAtPlxyXG4gICAgICBwb3MgPSBuIC8gc2V0dGluZ3Muc2VnbWVudENvdW50XHJcbiAgICAgIGRlZyA9IC1NYXRoLlBJICsgcG9zICogTWF0aC5QSVxyXG4gICAgICBNYXRoLnNpbihkZWcpICogcmFkXHJcblxyXG4gICAgYXJjR3JvdXAuc2VsZWN0QWxsKCcudGlja3MnKS5kYXRhKFswIC4uIHNldHRpbmdzLnNlZ21lbnRDb3VudF0pLmVudGVyKCkuYXBwZW5kKCdsaW5lJylcclxuICAgICAgLmF0dHIoJ2NsYXNzJywgJ3RpY2snKVxyXG4gICAgICAuYXR0cigneDEnLCAoZCkgLT4gZ2V0VGlja1goZCwgMTEwKSlcclxuICAgICAgLmF0dHIoJ3kxJywgKGQpIC0+IGdldFRpY2tZKGQsIDExMCkpXHJcbiAgICAgIC5hdHRyKCd4MicsIChkKSAtPiBnZXRUaWNrWChkLCA4NSkpXHJcbiAgICAgIC5hdHRyKCd5MicsIChkKSAtPiBnZXRUaWNrWShkLCA4NSkpXHJcblxyXG4gICAgdGlja1NjYWxlID0gZDMuc2NhbGUubGluZWFyKCkucmFuZ2UoW3NldHRpbmdzLm1pbiwgc2V0dGluZ3MubWF4XSlcclxuXHJcbiAgICBhcmNHcm91cC5zZWxlY3RBbGwoJy50aWNrcycpLmRhdGEoWzAgLi4gc2V0dGluZ3Muc2VnbWVudENvdW50XSkuZW50ZXIoKS5hcHBlbmQoJ3RleHQnKVxyXG4gICAgICAuYXR0ciAnY2xhc3MnLCAoZCkgLT5cclxuICAgICAgICBpZiAhZCBcclxuICAgICAgICAgIHJldHVybiAnZmlyc3QgdGlja1RleHQnXHJcbiAgICAgICAgaWYgZCA9PSBzZXR0aW5ncy5zZWdtZW50Q291bnRcclxuICAgICAgICAgIHJldHVybiAnbGFzdCB0aWNrVGV4dCdcclxuICAgICAgICAndGlja1RleHQnXHJcbiAgICAgIC5hdHRyKCd4JywgKGQpIC0+IGdldFRpY2tYKGQsIDEyMikpXHJcbiAgICAgIC5hdHRyKCd5JywgKGQpIC0+IGdldFRpY2tZKGQsIDEyMikpXHJcbiAgICAgIC50ZXh0KChkKSAtPiBzZXR0aW5ncy50aWNrRm9ybWF0dGVyKCB0aWNrU2NhbGUoZC9zZXR0aW5ncy5zZWdtZW50Q291bnQpICkpXHJcblxyXG4gICAgZ2F1Z2UudXBkYXRlID0gKCkgLT5cclxuICAgICAgc2NhbGUgPSBkMy5zY2FsZS5saW5lYXIoKS5kb21haW4oW3NldHRpbmdzLm1pbiwgc2V0dGluZ3MubWF4XSkucmFuZ2UoWzAsIDFdKVxyXG5cclxuICAgICAgYXJjRWxtLnRyYW5zaXRpb24oKS5kdXJhdGlvbihzZXR0aW5ncy5kdXJhdGlvbikuZWFzZSgnZWxhc3RpYycpXHJcbiAgICAgICAgLmF0dHJUd2VlbignZCcsIGFyY1R3ZWVuKGFyYywgc2V0dGluZ3MucmVuZGVyVmFsdWUsIHNjYWxlKHNldHRpbmdzLnZhbHVlKSkgKVxyXG5cclxuICAgICAgc2V0dGluZ3MucmVuZGVyVmFsdWUgPSBzY2FsZShzZXR0aW5ncy52YWx1ZSlcclxuXHJcbiAgICAgIHRleHQudGV4dCggc2V0dGluZ3MudmFsdWVGb3JtYXR0ZXIoKHNldHRpbmdzLnZhbHVlKSkgKVxyXG5cclxuXHJcbiAgIyBhZGQgZ2V0dGVyL3NldHRlci9jaGFpbmFibGUgdG8gcmV0dXJuZWQgZ2VuZXJhdG9yIGZ1bmN0aW9uXHJcbiAgcGx1Z2luLmFkZENvbmZpZ3VyYXRpb25zKHNldHRpbmdzLCBnYXVnZSxcclxuICAgIFsnbWluJywgJ21heCcsICd2YWx1ZScsICd0ZXh0JywgJ3NlZ21lbnRDb3VudCcsICd0aWNrRm9ybWF0dGVyJywgICd2YWx1ZUZvcm1hdHRlcicsICdkdXJhdGlvbicgXSxcclxuICAgIFsgMCwgICAgIDEwMCwgICA1MCwgICAgICAnJywgICAgIDUsICAgICAgICAgICAgICBkMy5mb3JtYXQoXCIuMWZcIiksIGQzLmZvcm1hdCgnLjFmJyksIDE1MDAgIF1cclxuICApXHJcbiAgXHJcbiAgIyByZXR1cm4gZ2VucmF0b3IgZnVuY3Rpb25cclxuICBnYXVnZVxyXG5cclxuIyBhY3R1YWwgc3RhcnQgb2YgdGhlIHByb2dyYW1tXHJcbmNvbnNvbGUubG9nICdnYXVnZSB0ZXN0IDIgc3RhcnQnXHJcblxyXG53aWR0aCAgPSAxMDAwXHJcbmhlaWdodCA9IDEwMDBcclxuXHJcbiMgY3JlYXRlIHN2Z1xyXG5zdmcgPSBkMy5zZWxlY3QoJ2JvZHknKS5hcHBlbmQoJ3N2ZycpXHJcbiAgLmF0dHIoJ3dpZHRoJywgd2lkdGgpXHJcbiAgLmF0dHIoJ2hlaWdodCcsIGhlaWdodClcclxuXHJcbiMgaW5zdGFuY2lhdGUgdGhlIHBsdWdpblxyXG5nYXVnZSA9IHBsdWdpbi5nYXVnZSgpXHJcbiAgLnRleHQoJ3BlcmZvcm1hbmNlJylcclxuICAuZHVyYXRpb24oNDAwMClcclxuICAuc2VnbWVudENvdW50KDMpXHJcblxyXG5nYXVnZTIgPSBwbHVnaW4uZ2F1Z2UoKVxyXG4gIC5taW4oLTEwKVxyXG4gIC5tYXgoNDApXHJcbiAgLnZhbHVlKDEwKVxyXG4gIC50ZXh0KCdsb2FkJylcclxuXHJcbmdhdWdlMyA9IHBsdWdpbi5nYXVnZSgpXHJcbiAgLnNlZ21lbnRDb3VudCgxMDApXHJcbiAgLnRpY2tGb3JtYXR0ZXIoKCktPicnKVxyXG4gIC52YWx1ZUZvcm1hdHRlcihkMy5mb3JtYXQoJ2QnKSlcclxuICAubWluKDEwMClcclxuICAubWF4KDUwMClcclxuICAudmFsdWUoMjAwKVxyXG5cclxud2luZG93LmdhdWdlID0gZ2F1Z2UyXHJcblxyXG4jIGFkZCBwbHVnaW4gdG8gc3ZnXHJcbnN2Zy5hcHBlbmQoJ2cnKVxyXG4gIC5hdHRyKCdpZCcsICdnYXVnZTEnKVxyXG4gIC5hdHRyKCdjbGFzcycsICdnYXVnZScpXHJcbiAgLmF0dHIoJ3RyYW5zZm9ybScsIFwidHJhbnNsYXRlKCN7NDAwfSwgI3szMDB9KSBzY2FsZSgyKVwiKVxyXG4gIC5jYWxsKGdhdWdlMilcclxuXHJcbnN2Zy5hcHBlbmQoJ2cnKVxyXG4gIC5hdHRyKCdjbGFzcycsICdnYXVnZScpXHJcbiAgLmF0dHIoJ3RyYW5zZm9ybScsIFwidHJhbnNsYXRlKCN7MjUwfSwgI3s2MDB9KSBzY2FsZSgxLjUpXCIpXHJcbiAgLmNhbGwoZ2F1Z2UpXHJcblxyXG5zdmcuYXBwZW5kKCdnJylcclxuICAuYXR0cignY2xhc3MnLCAnZ2F1Z2UnKVxyXG4gIC5hdHRyKCd0cmFuc2Zvcm0nLCBcInRyYW5zbGF0ZSgjezcwMH0sICN7NjAwfSkgc2NhbGUoMS41KVwiKVxyXG4gIC5jYWxsKGdhdWdlMylcclxuXHJcbnNldEludGVydmFsICgpIC0+XHJcbiAgIyBzZXQgdGhlIHZhbHVlIHRvIGEgcmFuZG9tIHZhbHVlIGluIHJhbmdlXHJcbiAgZ2F1Z2UyLnZhbHVlKCAoTWF0aC5yYW5kb20oKSAqIChnYXVnZTIubWF4KCktZ2F1Z2UyLm1pbigpKSArIGdhdWdlMi5taW4oKSApKS51cGRhdGUoKVxyXG4sIDMwMDBcclxuXHJcbnNldEludGVydmFsICgpIC0+XHJcbiAgZ2F1Z2UzLnZhbHVlKCAoZ2F1Z2UzLnZhbHVlKCkrMSkgJSBnYXVnZTMubWF4KCkgKS51cGRhdGUoKVxyXG4sIDEwXHJcblxyXG5zZXRJbnRlcnZhbCAoKSAtPlxyXG4gIGdhdWdlLnZhbHVlKCAoTWF0aC5yYW5kb20oKSAqIChnYXVnZS5tYXgoKS1nYXVnZS5taW4oKSkgKyBnYXVnZS5taW4oKSApKS51cGRhdGUoKVxyXG4sIDUwMDAiXX0=