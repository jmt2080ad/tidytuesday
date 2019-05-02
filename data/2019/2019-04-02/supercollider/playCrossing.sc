
// Todo:
// - find crossings that are complete cases, or close to it.
// Outline:
// 1. load collections into memory
// 3. make 12 synth defs defining the 12 crossings, with Line.ar on amplitude
// 4. play each synthdef
// 0. sequence 
// 5. map each buffer bus to set Line.ar in synthdef


s.reboot;


~dir = PathName.new("./data");
~cd = ~dir.files.collect({
	arg file;
	file.fullPath.loadRelative();
});
~rate = (1/12);
~freq = 40.midicps;
~cd.do({
	arg itm, idx;
	if((idx % 2 == 0) && (idx != 0),{~freq = ~freq + 36.midicps});
	SynthDef('c' ++ idx ++ 'sd', {
		arg amp, t_ampGate, rate;
		var env, sig;
		amp = amp.linlin(0, 300, 0, 1);
		env = EnvGen.ar(Env.new([0, amp], [~rate]), t_ampGate);
		sig = SinOsc.ar(~freq) * amp * env;		
		Out.ar((idx % 2), sig);
	}).add;
});

~cs = ~cd.collect({
	arg itm, idx;
	Synth.new('c' ++ idx ++ 'sd',
		[
			\amp, 0,
			\t_ampGate, 0
		]
	);
});

SynthDef('chime', {
	var env, sig;
	env = EnvGen.ar(Env.perc(0.05, 0.05), doneAction:2);
	sig = SinOsc.ar(100) * env * 0.5;
	Out.ar(0, [sig, sig]);
}).add;

(
Routine {
	~cd[0][0].size.do({
		arg itm1, idx1;
		~cs.do({
			arg itm2, idx2;
			itm2.set(\amp, ~cd[idx2][0][idx1], \t_ampGate, 1);
		});
		if((idx1 % 6) == 0,{ Synth.new('chime') });
		~rate.wait;
	});
}.play;
)

s.plotTree;
s.scope;