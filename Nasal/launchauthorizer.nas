props.globals.initNode("/sim/is-MP-Aircraft", 0, "BOOL");
##########################################
# Primitive Range Finder for guns and Rockets
##########################################
props.globals.initNode("/controls/armament/LAMarkerON", 0, "BOOL");
props.globals.initNode("/controls/armament/laserrange", 0, "DOUBLE");
props.globals.initNode("/controls/armament/pipperoffset", 0, "DOUBLE");
props.globals.initNode("/controls/armament/weapon-type", 2, "DOUBLE");


var range = 0.0;
var LArange = 5500.0;
var LAmarkerON = 0;
var range_index = 0.0;
var dive_index = 0.0;
var pipper_offset = 0.001;
var master_arm = 0;
var selected_wpn = 0.0;
var ac_pitch = 0.0;
var ac_alt = 0.0;
var is_bomb = 0.0;

var WeaponsHot = func{
var LAmarkerON = getprop("/controls/armament/LAMarkerON");
var selected_wpn = getprop("controls/armament/weapon-type");
var master_arm = getprop("controls/armament/master-arm");
var ac_pitch = getprop("/orientation/pitch-deg");
var ac_alt = getprop("/position/altitude-agl-ft");
var sin_pitch = math.sin(-ac_pitch *D2R);
var range = ac_alt/sin_pitch;

if (master_arm == 1){
RangeSet.start();
}
else{
RangeSet.stop();
RangeTest.stop();
setprop("/controls/armament/LAMarkerON", 0);

}
}

#meters to feet table *by3.281
#1000m=3280.84ft
#1500m=4921.26ft
#2000m=6561.68ft
#2500m=8202.1ft
#3000m=9842.52ft
#3500m=11482.94ft
#4000m=13123.36ft

setlistener("controls/armament/master-arm", WeaponsHot);


var RangeSet = maketimer (0.1, func()
{
#YakB-12.7 mm machinegun
if (getprop("controls/armament/weapon-type") == 1){
LArange = 2500.0;
range_index = 0.05;
is_bomb = 0.1;
setprop("/controls/armament/larange", LArange);
RangeTest.start();
#screen.log.write("LA Range 2500", 1, 0.6, 0.1);
}
#Rockets
if (getprop("controls/armament/weapon-type") == 2){
LArange = 4000.0;
range_index = 0.1;
is_bomb = 0.01;
setprop("/controls/armament/larange", LArange);
RangeTest.start();
#screen.log.write("LA Range 4000м", 1, 0.6, 0.1);
}
#FAB-250
if (getprop("controls/armament/weapon-type") == 3){
LArange = 2500.0;
range_index = 0.6;
is_bomb = 1.4;
setprop("/controls/armament/larange", LArange);
RangeTest.start();
#screen.log.write("LA Range 3000м", 1, 0.6, 0.1);
}
#FAB-500
if (getprop("controls/armament/weapon-type") == 4){
LArange = 2500.0;
range_index = 0.6;
is_bomb = 1.5;
setprop("/controls/armament/larange", LArange);
RangeTest.start();
#screen.log.write("LA Range 3000м", 1, 0.6, 0.1);
}
#Laser guided missile
if (getprop("controls/armament/weapon-type") == 0){
LArange = 8000.0;
range_index = 0.0;
is_bomb = 0.0;
setprop("/controls/armament/larange", LArange);
RangeTest.start();
#screen.log.write("LA Range 8000м", 1, 0.6, 0.1);
}
#else{
#LArange = 5000.0;
#screen.log.write("Range Test OFF", 1, 0.6, 0.1);
#RangeTest.stop();
#}
});

var RangeTest = maketimer (0.02, func()
{
var ac_pitch = getprop("/orientation/pitch-deg");
var ac_alt = getprop("/position/altitude-agl-ft");
var sin_pitch = math.sin(-ac_pitch *D2R);
var range = ac_alt/sin_pitch/3.281;
var dive_index = is_bomb*(ac_pitch+90)/100;
var pipper_offset = range*0.00001*(range_index+dive_index);

if (ac_pitch < 0 and range < LArange and range < 15000.0){
setprop("/controls/armament/LAMarkerON", 1);
setprop("/controls/armament/laserrange", range);
setprop("/controls/armament/pipperoffset", pipper_offset);
#screen.log.write("In range", 1, 0.6, 0.1);
}
elsif (ac_pitch < 0 and range > LArange and range < 15000.0){
setprop("/controls/armament/laserrange", range);
setprop("/controls/armament/LAMarkerON", 0);
setprop("/controls/armament/pipperoffset", pipper_offset);
#screen.log.write("Laser ON", 1, 0.6, 0.1);
}
else{
setprop("/controls/armament/LAMarkerON", 0);
setprop("/controls/armament/laserrange", 0);
setprop("/controls/armament/pipperoffset", 0.001);
#screen.log.write("Range Test OFF", 1, 0.6, 0.1);
}
});
