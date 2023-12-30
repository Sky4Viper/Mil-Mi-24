var RangeTest9m120 = maketimer (0.02, func() {
  var ac_pitch      = getprop("/orientation/pitch-deg");
  var ac_alt        = getprop("/position/altitude-agl-ft");
  var sin_pitch     = math.sin(-ac_pitch *D2R);
  var range         = ac_alt/sin_pitch/3.281;
  var dive_index    = is_bomb*(ac_pitch+90)/100;
  var pipper_offset = range*0.00001*(range_index+dive_index);
  var ac_heading    = getprop("/orientation/heading-deg");
  var tgt_bearing   = getprop("/tracking/bearing");
  var tgt_range_km  = getprop("/tracking/rng-km");
  var tgt_locked    = getprop("/tracking/tgt-designated");
  var tgt_limit     = 30.0;
  var tgt_offset_abs = abs(abs(ac_heading -360) -abs(tgt_bearing -360));
  #var tgt_pitch_tan = ((math.tan(ac_alt/3.281/(tgt_range_km*1000))) /D2R);
  #var tgt_sensor_pitch = (tgt_pitch_tan +ac_pitch);
  #screen.log.write(tgt_offset_abs, 1, 0.6, 0.1);
  #screen.log.write(tgt_pitch_tan, 1, 0.6, 0.1);
  #screen.log.write(tgt_sensor_pitch, 1, 0.8, 0.1);

  if (tgt_locked and tgt_range_km < 6.0 and tgt_range_km > 1.0 and tgt_offset_abs <tgt_limit) {
    var tgt_pitch_tan = ((math.tan(ac_alt/3.281/(tgt_range_km*1000))) /D2R);
    var tgt_sensor_pitch = (tgt_pitch_tan +ac_pitch);
    var tgt_sensor_hdg = (ac_heading -tgt_bearing);
    var my_view_number = getprop("/sim/current-view/view-number");
    setprop("/controls/armament/LAMarkerON", 0);
    setprop("/controls/armament/ataka-inrange", 1);
    setprop("/controls/armament/laserrange", range);
    setprop("/controls/armament/pipperoffset", 0.001);
    setprop("/controls/armament/ataka_pitch_offset", -tgt_sensor_pitch);
    setprop("/controls/armament/ataka_heading_offset", -tgt_sensor_hdg);
    if (my_view_number == 8){
      setprop("/sim/current-view/heading-offset-deg", tgt_sensor_hdg);
      setprop("/sim/current-view/pitch-offset-deg", -tgt_pitch_tan);
      screen.log.write("Padlock", 1, 0.6, 0.1);
    }
    #screen.log.write("In range", 1, 0.6, 0.1);
    #screen.log.write(tgt_pitch_tan, 1, 0.6, 0.1);
    #screen.log.write(tgt_sensor_pitch, 1, 0.8, 0.1);
    #screen.log.write(tgt_sensor_hdg, 1, 0.8, 0.1);
    #"/sim/current-view/heading-offset-deg"
    #"/sim/current-view/pitch-offset-deg"
    #"sim/current-view/view-number"
  } else {
    setprop("/controls/armament/LAMarkerON", 0);
    setprop("/controls/armament/ataka-inrange", 0);
    setprop("/controls/armament/laserrange", 0);
    setprop("/controls/armament/pipperoffset", 0.001);
    setprop("/controls/armament/ataka_pitch_offset", 0.0);
    #screen.log.write("Range Test OFF", 1, 0.6, 0.1);
  }
});