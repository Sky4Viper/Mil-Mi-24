props.globals.initNode("/sim/is-MP-Aircraft", 0, "BOOL");
##########################################
# Primitive Range Finder for guns and Rockets
##########################################
props.globals.initNode("/controls/armament/LAMarkerON", 0, "BOOL");
props.globals.initNode("/controls/armament/ataka-index", -0.1, "DOUBLE");
props.globals.initNode("/controls/armament/sensor-index", 0.001, "DOUBLE");
props.globals.initNode("/controls/armament/ataka-inrange", 0, "BOOL");
props.globals.initNode("/controls/electric/gunsight-auto", 0, "BOOL");
props.globals.initNode("/controls/armament/laserrange", 0, "DOUBLE");
#props.globals.initNode("/controls/armament/pipperoffset", 0, "DOUBLE");
props.globals.initNode("/controls/armament/pipper_offset_h", 0, "DOUBLE");
props.globals.initNode("/controls/armament/pipper_offset_v", 0, "DOUBLE");
props.globals.initNode("/controls/armament/weapon-type", 2, "DOUBLE");
props.globals.initNode("/controls/armament/ataka_pitch_offset", 0, "DOUBLE");
props.globals.initNode("/controls/armament/ataka_heading_offset", 0, "DOUBLE");

var range         = 0.0;
var LArange       = 5500.0;
var LAmarkerON    = 0;
var range_index   = 0.0;
var dive_index    = 0.0;
var pipper_offset = 0.001;
var master_arm    = 0;
var selected_wpn  = 0.0;
var ac_pitch      = 0.0;
var ac_alt        = 0.0;
var ac_heading    = 0.0;
var is_bomb       = 0.0;
var tgt_locked    = 0;
var tgt_bearing   = 0.0;
var tgt_range_km  = 0.0;
var sensor_limit_horiz   =  30.0;
var sensor_pitch_min     = -15.0;
var sensor_pitch_max     =  20.0;
var sensor_range_min     =  0.4;
var sensor_range_max     =  6.0;
var mi24type = getprop("/sim/variant-id");

var WeaponsHot = func{
  var LAmarkerON   = getprop("/controls/armament/LAMarkerON");
  var selected_wpn = getprop("controls/armament/weapon-type");
  var master_arm   = getprop("controls/armament/master-arm");
  var ac_pitch     = getprop("/orientation/pitch-deg");
  var ac_alt       = getprop("/position/altitude-agl-ft");
  var sin_pitch    = math.sin(-ac_pitch *D2R);
  var range        = ac_alt/sin_pitch;

  if (master_arm == 1) {
    RangeSet.start();
  } else {
    RangeSet.stop();
    RangeTest.stop();
    RangeTest9m120.stop();
    setprop("/controls/armament/LAMarkerON", 0);
    setprop("/controls/armament/ataka-inrange", 0);
  }
}

# meters to feet table *by3.281
# 1000 m =  3280.84 ft
# 1500 m =  4921.26 ft
# 2000 m =  6561.68 ft
# 2500 m =  8202.10 ft
# 3000 m =  9842.52 ft
# 3500 m = 11482.94 ft
# 4000 m = 13123.36 ft

setlistener("controls/armament/master-arm", WeaponsHot);

var RangeSet = maketimer (0.1, func() {
  var typeweapon = getprop("controls/armament/weapon-type");
  #var mi24type = getprop("/sim/variant-id");
  if (typeweapon == 1 and mi24type ==1) {
    #                                      YakB-12.7 mm machinegun
    LArange     = 2500.0;
    range_index = 0.05;
    is_bomb     = 0.1;
    sensor_limit_horiz   =  90.0;
    sensor_pitch_min     = -25.0;
    sensor_pitch_max     =  25.0;
    sensor_range_min     =  0.4;
    sensor_range_max     =  3.0;
    setprop("/controls/armament/larange", LArange);
    RangeTest.stop();
    RangeTest9m120.start();
    #screen.log.write("LA Range 2500", 1, 0.6, 0.1);
  } elsif (typeweapon == 1 and mi24type ==2) {
    #                                      Rockets
    LArange = 3500.0;
    range_index = 0.1;
    is_bomb = 0.01;
    setprop("/controls/armament/larange", LArange);
    RangeTest9m120.stop();
    RangeTest.start();
    #screen.log.write("LA Range 4000 m", 1, 0.6, 0.1);
  } elsif (typeweapon == 2) {
    #                                      Rockets
    LArange = 3500.0;
    range_index = 0.1;
    is_bomb = 0.01;
    setprop("/controls/armament/larange", LArange);
    RangeTest9m120.stop();
    RangeTest.start();
    #screen.log.write("LA Range 4000 m", 1, 0.6, 0.1);
  } elsif (typeweapon >= 3 and typeweapon <= 6) {
    #                                      Ataka-1
    LArange = 6000.0;
    range_index = 0.1;
    is_bomb = 0.01;
    sensor_limit_horiz   =  30.0;
    sensor_pitch_min     = -15.0;
    sensor_pitch_max     =  20.0;
    sensor_range_min     =  0.4;
    sensor_range_max     =  6.0;
    setprop("/controls/armament/larange", LArange);
    RangeTest.stop();
    RangeTest9m120.start();
    #screen.log.write("LA Range 6000 m", 1, 0.6, 0.1);
  } elsif (typeweapon  == 0) {
    #                                      Laser guided missile
    LArange = 8000.0;
    range_index = 0.0;
    is_bomb = 0.0;
    setprop("/controls/armament/larange", LArange);
    RangeTest.start();
    #screen.log.write("LA Range 8000 m", 1, 0.6, 0.1);
  } else {
    LArange = 5000.0;
    screen.log.write("Range Test OFF", 1, 0.6, 0.1);
    RangeTest.stop();
    RangeTest9m120.stop();
  }
});

var RangeTest = maketimer (0.02, func() {
  var ac_pitch      = getprop("/orientation/pitch-deg");
  var ac_alt        = getprop("/position/altitude-agl-ft");
  var sin_pitch     = math.sin(-ac_pitch *D2R);
  var range         = ac_alt/sin_pitch/3.281;
  var dive_index    = is_bomb*(ac_pitch+90)/100;
  var pipper_offset = range*0.01*(range_index+dive_index)*-1;

  if (ac_pitch < 0 and range < LArange and range < 15000.0) {
    setprop("/controls/armament/LAMarkerON", 1);
    setprop("/controls/armament/laserrange", range);
    #setprop("/controls/armament/pipperoffset", pipper_offset);
    setprop("/controls/armament/pipper_offset_h", 0.0);
    setprop("/controls/armament/pipper_offset_v", pipper_offset);
    #screen.log.write("In range", 1, 0.6, 0.1);
  } elsif (ac_pitch < 0 and range > LArange and range < 15000.0) {
    setprop("/controls/armament/laserrange", range);
    setprop("/controls/armament/LAMarkerON", 0);
    setprop("/controls/armament/ataka-inrange", 0);
    #setprop("/controls/armament/pipperoffset", pipper_offset);
    setprop("/controls/armament/ataka_heading_offset", 0.0);
    setprop("/controls/armament/pipper_offset_h", 0.0);
    setprop("/controls/armament/pipper_offset_v", pipper_offset);
    #screen.log.write("Laser ON", 1, 0.6, 0.1);
  } else {
    setprop("/controls/armament/LAMarkerON", 0);
    setprop("/controls/armament/laserrange", 0);
    setprop("/controls/armament/ataka-inrange", 0);
    #setprop("/controls/armament/pipperoffset", 0.001);
    setprop("/controls/armament/pipper_offset_h", 0.0);
    setprop("/controls/armament/pipper_offset_v", 0.0);
    setprop("/controls/armament/ataka-inrange", 0);
    setprop("/controls/armament/ataka_heading_offset", 0.0);
    setprop("/controls/armament/ataka_pitch_offset", 0.0);
    #screen.log.write("Range Test OFF", 1, 0.6, 0.1);
  }
});

var RangeTest9m120 = maketimer (0.02, func() {
  var ac_pitch      = getprop("/orientation/pitch-deg");
  var ac_alt        = getprop("/position/altitude-agl-ft");
  var ac_heading    = getprop("/orientation/heading-deg");
  var tgt_bearing   = getprop("/tracking/bearing");
  var tgt_range_km  = getprop("/tracking/rng-km");
  var tgt_locked    = getprop("/tracking/tgt-designated");
  var mis_index     = getprop("/controls/armament/ataka-index");
  var sen_index     = getprop("/controls/armament/sensor-index");
  var missile_alt   = ac_alt;
  var view_alt      = ac_alt;
  var dive_index    = is_bomb*(ac_pitch+90)/100;

  var tgt_offset_abs = abs(abs(ac_heading -360) -abs(tgt_bearing -360));
  var tgt_missile_pitch_tan = ((math.tan(missile_alt/3.281/((tgt_range_km +mis_index)*1000))) /D2R);
  var tgt_sensor_pitch_tan  = ((math.tan(view_alt/3.281/((tgt_range_km -sen_index)*1000))) /D2R);
  var tgt_missile_pitch = (tgt_missile_pitch_tan +ac_pitch);
  var tgt_sensor_pitch = (tgt_sensor_pitch_tan +ac_pitch);
  var tgt_sensor_hdg = (ac_heading -tgt_bearing);

  #9M120 (tandem HEAT) 0.4-6 km
  #9M120 (termobaric Anti-personnel) 1-5.8 km
  #9M220O (proximyty fuse anti air) 0.4-7 km
  #9M120M (Modernized anti-tank variant) 0.8-8 km

  if (tgt_locked and tgt_range_km < sensor_range_max and tgt_range_km > sensor_range_min and tgt_offset_abs < sensor_limit_horiz and tgt_sensor_pitch < sensor_pitch_max and tgt_sensor_pitch > sensor_pitch_min) {
    var my_view_number = getprop("/sim/current-view/view-number-raw");
    var gunsight_auto = getprop("controls/electric/gunsight-auto");
    var selected_wpn = getprop("controls/armament/weapon-type");
    setprop("/controls/armament/LAMarkerON", 0);
    setprop("/controls/armament/ataka-inrange", 1);
    setprop("/controls/armament/ataka_heading_offset", -tgt_sensor_hdg);
    setprop("/controls/armament/ataka_pitch_offset", -tgt_missile_pitch);
    setprop("/controls/armament/pipper_offset_h", tgt_sensor_hdg);
    setprop("/controls/armament/pipper_offset_v", -tgt_missile_pitch);
    if (my_view_number == 100 and gunsight_auto){
      setprop("/sim/current-view/heading-offset-deg", tgt_sensor_hdg);
      setprop("/sim/current-view/pitch-offset-deg", -tgt_sensor_pitch);
      #setprop("/controls/armament/ataka-index", 180.0);
      #screen.log.write("View lock", 1, 0.6, 0.1);
    } elsif (my_view_number != 100 and gunsight_auto and selected_wpn ==1 and mi24type ==1){
      setprop("/sim/model/turret[0]/heading", -tgt_sensor_hdg);
      setprop("/sim/model/turret[0]/pitch", -tgt_sensor_pitch);
      #setprop("/controls/armament/ataka-index", 180.0);
      #screen.log.write("Turret lock", 1, 0.6, 0.1);
    }
    #screen.log.write("In range", 1, 0.6, 0.1);
    #screen.log.write(tgt_pitch_sin, 1, 0.6, 0.1);
    #screen.log.write(tgt_sensor_pitch, 1, 0.8, 0.1);
    #screen.log.write(tgt_sensor_hdg, 1, 0.8, 0.1);
  } else {
    setprop("/controls/armament/LAMarkerON", 0);
    setprop("/controls/armament/ataka-inrange", 0);
    setprop("/controls/armament/laserrange", 0);
    #setprop("/controls/armament/pipperoffset", 0.001);
    setprop("/controls/armament/pipper_offset_h", 0.0);
    setprop("/controls/armament/pipper_offset_v", 0.0);
    setprop("/controls/armament/ataka_heading_offset", 0.0);
    setprop("/controls/armament/ataka_pitch_offset", 0.0);
    #screen.log.write("Range Test OFF", 1, 0.6, 0.1);
  }
});
