################
#              #
#  gmeter.nas  #
#              #
# 2013 Helijah #
# 2014 Helijah #
################

var pilot_g = props.globals.getNode("accelerations/pilot-g", 1);
var g_max   = props.globals.getNode("accelerations/g-max", 1);
var g_min   = props.globals.getNode("accelerations/g-min", 1);

pilot_g.setDoubleValue(0);
g_min.setDoubleValue(0);
g_max.setDoubleValue(0);

var loop = func {

  var g    = pilot_g.getValue();
  var gmin = g_min.getValue();
  var gmax = g_max.getValue();

  if (g < gmin) {
    gmin = g;
  }

  if (g > gmax) {
    gmax = g;
  }

  setprop("accelerations/g-max", gmax);
  setprop("accelerations/g-min", gmin);

  settimer(loop, 0);
}

loop();
