var sbc1 = aircraft.light.new( "/sim/model/lights/sbc1", [0.5, 0.3] );
sbc1.interval = 0.1;
sbc1.switch( 1 );

var sbc2 = aircraft.light.new( "/sim/model/lights/sbc2", [0.2, 0.3], "/sim/model/lights/sbc1/state" );
sbc2.interval = 0;
sbc2.switch( 1 );

var landingSwitch = "/controls/lighting/landing-lights";
var taxiSwitch = "/controls/lighting/taxi-lights";
gearBind = 1;

setlistener( "/sim/model/lights/sbc2/state", func(n) {
  var bsbc1 = sbc1.stateN.getValue();
  var bsbc2 = n.getBoolValue();
  var b = 0;
  if( bsbc1 and bsbc2 and getprop( "/controls/lighting/beacon") ) {
    b = 1;
  } else {
    b = 0;
  }
  setprop( "/sim/model/lights/beacon/enabled", b );

  if( bsbc1 and !bsbc2 and getprop( "/controls/lighting/strobe" ) ) {
    b = 1;
  } else {
    b = 0;
  }
  setprop( "/sim/model/lights/strobe/enabled", b );
});

var beacon = aircraft.light.new( "/sim/model/lights/beacon", [0.05, 0.05] );
beacon.interval = 0;

var strobe = aircraft.light.new( "/sim/model/lights/strobe", [0.05, 0.05, 0.05, 1] );
strobe.interval = 0;

#enable binding to gear
if(gearBind) {
	setlistener("/controls/gear/gear-down", func {
		gearDown = getprop("/controls/gear/gear-down");
		if(gearDown) {
			if(landingSwitch!=nil and landingSwitch!=0) setprop(landingSwitch, 1);
			if(taxiSwitch!=nil and taxiSwitch!=0) setprop(taxiSwitch, 1);
		}
		else{
			if(landingSwitch!=nil and landingSwitch!= 0) setprop(landingSwitch, 0);
			if(taxiSwitch!=nil and taxiSwitch!=0) setprop(taxiSwitch, 0);
		}
	});
}

print("Light system initialized");
