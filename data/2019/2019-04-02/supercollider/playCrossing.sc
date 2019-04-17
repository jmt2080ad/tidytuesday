
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

~rate = (1/24);
~freq = 60.midicps;
~cs = ~cd.collect({
	arg itm, idx;
	if((idx % 2 == 0) && (idx != 0),{~freq = ~freq + 24.midicps});
	// ~freq.postln;
	// ((idx % 2 == 0) && (idx != 0)).postln;
	SynthDef('c' ++ idx ++ 'sd', {
		arg amp, rate;
		var env, sig;
		amp = amp.linlin(0, 400, 0, 1);
		env = EnvGen.ar(Env.new([0, 1, 0], [~rate, ~rate]), doneAction:2);
		sig = FSinOsc.ar(~freq) * amp * env;		
		Out.ar((idx % 2), sig);
	}).add;
});

(
SynthDef('chime', {
	var env, sig;
	env = EnvGen.ar(Env.perc(0.1, 0.1), doneAction:2);
	sig = SinOsc.ar(300) * env * 0.2;
	Out.ar(0, [sig, sig]);
}).add;
)

(
Routine {
	6000.do({
		arg itm1, idx1;
		~cd.do({
			arg itm2, idx2;
			Synth.new('c' ++ idx2 ++ 'sd',
				[
					\amp, ~cd[idx2][0][idx1],
				]
			);
		});
		if((idx1 % 12) == 0,{ Synth.new('chime') });
		~rate.wait;
	});
}.play;
)


s.plotTree;
s.scope;