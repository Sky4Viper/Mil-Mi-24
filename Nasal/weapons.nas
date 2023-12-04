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

	if(getprop("controls/armament/trigger") == 1) {
				# var S8mounted1 = (getprop("sim/weight[0]/selected") == "UB-16 rockets pod");
				# var S5mounted2 = (getprop("sim/weight[1]/selected") == "UB-16 rockets pod");
				# var PK3mounted1 = (getprop("sim/weight[0]/selected") == "PK-3 MG pod");
				# var PK3mounted2 = (getprop("sim/weight[1]/selected") == "PK-3 MG pod");
				# var Pylons14_ON = (getprop("controls/armament/pylon-outer-sel") == 1);
				# var Pylons23_ON = (getprop("controls/armament/pylon-inner-sel") == 1);
				
				var PickleState = (getprop("controls/armament/trigger") ==1);

                MasterArm = getprop("controls/armament/master-arm");
				GunsON = (getprop("controls/armament/weapon-type") ==1);
        #         BombsON = getprop("controls/armament/bombs-sel");
				# BombMode = getprop("controls/armament/bomb-mode");
                S8RocketsON = (getprop("controls/armament/weapon-type") ==2);

				if(MasterArm and S8RocketsON) {
					#screen.log.write("Fire selected weapon: Rockets ", 1, 0.6, 0.1);
					print("Fire selected weapon: Rockets");
                    setprop("/controls/armament/fire-s8-rockets", 1);
				}
				if(MasterArm and GunsON) {
					#screen.log.write("Fire selected weapon: PK-3 pods ", 1, 0.6, 0.1);
					print("Fire selected weapon: PK-3");
                    setprop("/controls/armament/trigger-mg", 1);
				}
			}
			else {
					#screen.log.write("Stop weapons release", 1, 0.1, 0.1);
					print("Stop weapons release");
					setprop("/controls/armament/trigger-mg", 0);
					setprop("/controls/armament/fire-s8-rockets", 0);
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

var flash_trigger = props.globals.getNode("controls/armament/trigger", 0);
var flash_trigger_mg = props.globals.getNode("controls/armament/trigger-mg", 0);
var flash_trigger_s8 = props.globals.getNode("controls/armament/fire-s8-rockets", 0);
var flash_pickle = props.globals.getNode("controls/armament/pickle", 0);

setlistener("controls/armament/trigger", Pickle);

