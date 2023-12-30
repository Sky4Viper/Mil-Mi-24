# for Flares
fire_Flare = func {
  setprop("/controls/armament/pickle", 1);
}

stop_Flare = func {
  setprop("/controls/armament/pickle", 0);
}

# var flash_pickle = props.globals.getNode("controls/armament/pickle", 0);

# for Rockets
fire_Rocket = func {
  if (getprop("controls/armament/master-arm") == 1){
  setprop("/controls/armament/fire-s8-rockets", 1);
  }
}

stop_Rocket = func {
  setprop("/controls/armament/fire-s8-rockets", 0);
}

# var flash_pickle = props.globals.getNode("controls/armament/fire-s8-rockets", 0);

# for Gun
fire_MG = func {
  if (getprop("controls/armament/master-arm") == 1){
  setprop("/controls/armament/trigger-mg", 1);
  }
}

stop_MG = func {
  setprop("/controls/armament/trigger-mg", 0);
}

# var flash_trigger_mg = props.globals.getNode("controls/armament/trigger-mg", 0);

Pickle = func {

  if (getprop("controls/armament/trigger") == 1) {
    # var S8mounted1  = (getprop("sim/weight[0]/selected") == "UB-16 rockets pod");
    # var S5mounted2  = (getprop("sim/weight[1]/selected") == "UB-16 rockets pod");
    # var PK3mounted1 = (getprop("sim/weight[0]/selected") == "PK-3 MG pod");
    # var PK3mounted2 = (getprop("sim/weight[1]/selected") == "PK-3 MG pod");
    # var Pylons14_ON = (getprop("controls/armament/pylon-outer-sel") == 1);
    # var Pylons23_ON = (getprop("controls/armament/pylon-inner-sel") == 1);

    var PickleState = (getprop("controls/armament/trigger") ==1);

    MasterArm   = getprop("controls/armament/master-arm");
    GunsON      = (getprop("controls/armament/weapon-type") ==1);
    # BombsON     = getprop("controls/armament/bombs-sel");
    # BombMode    = getprop("controls/armament/bomb-mode");
    S8RocketsON = (getprop("controls/armament/weapon-type") ==2);
    Ataka1ON = (getprop("controls/armament/weapon-type") ==3);
    Ataka2ON = (getprop("controls/armament/weapon-type") ==4);
    Ataka3ON = (getprop("controls/armament/weapon-type") ==5);
    Ataka4ON = (getprop("controls/armament/weapon-type") ==6);

    Ataka1OUT = (getprop("controls/armament/station[0]/release-stick") ==1);
    Ataka2OUT = (getprop("controls/armament/station[1]/release-stick") ==1);
    Ataka3OUT = (getprop("controls/armament/station[2]/release-stick") ==1);
    Ataka4OUT = (getprop("controls/armament/station[3]/release-stick") ==1);

    if (MasterArm and S8RocketsON) {
      #screen.log.write("Fire selected weapon: Rockets ", 1, 0.6, 0.1);
      print("Fire selected weapon: Rockets");
      setprop("/controls/armament/fire-s8-rockets", 1);
    }
    if (MasterArm and GunsON) {
      #screen.log.write("Fire selected weapon: PK-3 pods ", 1, 0.6, 0.1);
      print("Fire selected weapon: Guns");
      setprop("/controls/armament/trigger-mg", 1);
    }
    if (MasterArm and Ataka1ON and !Ataka1OUT) {
      #screen.log.write("Fire selected weapon: Ataka Guided Missiles ", 1, 0.6, 0.1);
      print("Fire selected weapon: 9M120 - 1");
      setprop("/controls/armament/trigger-9m-1", 1);
      #setprop("/controls/armament/station[0]/release-stick", 1);
      hide_9m120_1.singleShot = 1; # timer will only be run once
			hide_9m120_1.start();
    }
    if (MasterArm and Ataka2ON and !Ataka2OUT) {
      #screen.log.write("Fire selected weapon: Ataka Guided Missiles ", 1, 0.6, 0.1);
      print("Fire selected weapon: 9M120 - 2");
      setprop("/controls/armament/trigger-9m-2", 1);
      #setprop("/controls/armament/station[1]/release-stick", 1);
      hide_9m120_2.singleShot = 1; # timer will only be run once
			hide_9m120_2.start();
    }
    if (MasterArm and Ataka3ON and !Ataka3OUT) {
      #screen.log.write("Fire selected weapon: Ataka Guided Missiles ", 1, 0.6, 0.1);
      print("Fire selected weapon: 9M120 - 3");
      setprop("/controls/armament/trigger-9m-3", 1);
      #setprop("/controls/armament/station[2]/release-stick", 1);
      hide_9m120_3.singleShot = 1; # timer will only be run once
			hide_9m120_3.start();
    }
    if (MasterArm and Ataka4ON and !Ataka4OUT) {
      #screen.log.write("Fire selected weapon: Ataka Guided Missiles ", 1, 0.6, 0.1);
      print("Fire selected weapon: 9M120 - 4");
      setprop("/controls/armament/trigger-9m-4", 1);
      #setprop("/controls/armament/station[3]/release-stick", 1);
      hide_9m120_4.singleShot = 1; # timer will only be run once
			hide_9m120_4.start();
    }
  } else {
    #screen.log.write("Stop weapons release", 1, 0.1, 0.1);
    print("Stop weapons release");
    setprop("/controls/armament/trigger-mg", 0);
    setprop("/controls/armament/fire-s8-rockets", 0);
    setprop("/controls/armament/trigger-9m-1", 0);
    setprop("/controls/armament/trigger-9m-2", 0);
    setprop("/controls/armament/trigger-9m-3", 0);
    setprop("/controls/armament/trigger-9m-4", 0);
  }
}

stop_Pickle = func {
  print("Stop all triggers");
  setprop("/sim/multiplay/generic/int[10]", 0); # YakB-127
  setprop("/sim/multiplay/generic/int[11]", 0); # S8 outer
  setprop("/sim/multiplay/generic/int[12]", 0); # S8 inner
  setprop("/sim/multiplay/generic/int[13]", 0); # GunPod Outer
  setprop("/sim/multiplay/generic/int[14]", 0); # GunPod Inner
  setprop("/sim/multiplay/generic/int[21]", 0); # Ataka-1
  setprop("/sim/multiplay/generic/int[22]", 0); # Ataka-2
  setprop("/sim/multiplay/generic/int[23]", 0); # Ataka-3
  setprop("/sim/multiplay/generic/int[24]", 0); # Ataka-4
  setprop("/controls/armament/trigger", 0);
}

var reload = func {
  if( getprop("/gear/gear[0]/wow") and getprop("/gear/gear[1]/wow") and getprop("/gear/gear[2]/wow") and (getprop("/velocities/groundspeed-kt") < 2) ) {

    setprop("/controls/armament/station[0]/release-stick", 0);
    setprop("/controls/armament/station[1]/release-stick", 0);
    setprop("/controls/armament/station[2]/release-stick", 0);
    setprop("/controls/armament/station[3]/release-stick", 0);

    screen.log.write("Ataka (9M120) missils reloaded", 1, 0.6, 0.1);
  } else {
    screen.log.write("You must be still on the ground to reaload! ", 1, 0.6, 0.1);
  }
}

var flash_trigger    = props.globals.getNode("controls/armament/trigger", 0);
var flash_trigger_mg = props.globals.getNode("controls/armament/trigger-mg", 0);
var flash_trigger_s8 = props.globals.getNode("controls/armament/fire-s8-rockets", 0);
var flash_trigger_9m1 = props.globals.getNode("controls/armament/trigger-9m-1", 0);
var flash_trigger_9m2 = props.globals.getNode("controls/armament/trigger-9m-2", 0);
var flash_trigger_9m3 = props.globals.getNode("controls/armament/trigger-9m-3", 0);
var flash_trigger_9m4 = props.globals.getNode("controls/armament/trigger-9m-4", 0);
var flash_pickle     = props.globals.getNode("controls/armament/pickle", 0);

#timers########################################################################################################

var hide_9m120_1 = maketimer(0.1, func(){
      setprop("/controls/armament/station[0]/release-stick", 1);
      stop_9m120.singleShot = 1; # timer will only be run once
		  stop_9m120.start();
});

var hide_9m120_2 = maketimer(0.1, func(){
      setprop("/controls/armament/station[1]/release-stick", 1);
      stop_9m120.singleShot = 1; # timer will only be run once
		  stop_9m120.start();
});

var hide_9m120_3 = maketimer(0.1, func(){
      setprop("/controls/armament/station[2]/release-stick", 1);
      stop_9m120.singleShot = 1; # timer will only be run once
		  stop_9m120.start();
});

var hide_9m120_4 = maketimer(0.1, func(){
      setprop("/controls/armament/station[3]/release-stick", 1);
      stop_9m120.singleShot = 1; # timer will only be run once
		  stop_9m120.start();
});

var stop_9m120 = maketimer(0.1, func(){
    setprop("/controls/armament/trigger-9m-1", 0);
    setprop("/controls/armament/trigger-9m-2", 0);
    setprop("/controls/armament/trigger-9m-3", 0);
    setprop("/controls/armament/trigger-9m-4", 0);
    setprop("/controls/armament/trigger", 0);
	  #fire_9m120.stop();
	  #screen.log.write("9M120 missile launched! ", 1, 0.6, 0.1);
});

setlistener("controls/armament/trigger", Pickle);
