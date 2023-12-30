#Place holder
var getTrackData = func {
# print("My tracking module got loaded!");
 var rngM=110000.0;
 var brg=0.0;
 var tgt=geo.click_position();
 var master_arm = getprop("controls/armament/master-arm");
 if (tgt != nil){
	#print ("ping");
	#setprop("/tracking/tgt-designated",1);
	var ac=geo.aircraft_position();
	var distance = ac.distance_to(tgt);
    var bearing =ac.course_to(tgt);
 	rngM=distance;
	brg=bearing;
	settimer(getTrackData, 0.1);
 }
 if (master_arm){
	setprop("/tracking/rng-km", rngM * 0.001);
	setprop("/tracking/rng-nml", rngM * 0.000539957);
	setprop("/tracking/bearing",brg);
	setprop("/tracking/tgt-designated",1);
 }
 else {
    setprop("/tracking/rng-km", 100.0);
	setprop("/tracking/rng-nml", 0.0);
	setprop("/tracking/bearing", 0.0);
	setprop("/tracking/tgt-designated", 0);
 }
}

setlistener("sim/signals/click", getTrackData,1);
