Engine_DND : CroneEngine {
    var <synth;

    *new { arg context, doneCallback;
        ^super.new(context, doneCallback);
    }

    alloc {
        synth = {
            arg out, osc1Freq, osc2Freq, osc3Freq, oscSlop, osc1Amp, osc2Amp, osc3Amp, osc1Fb, osc2Fb, osc3Fb, noiseAmp, filterFreq, filterRes;
            var slopOsc = LFNoise0.ar(osc1Freq);
            var osc1 = SinOscFB.ar(osc1Freq + (slopOsc*oscSlop), osc1Fb) * Lag.kr(osc1Amp, 0.1);
	    var osc2 = SinOscFB.ar(osc2Freq + (slopOsc*oscSlop), osc2Fb) * Lag.kr(osc2Amp, 0.1);
	    var osc3 = SinOscFB.ar(osc3Freq + (slopOsc*oscSlop), osc3Fb) * Lag.kr(osc3Amp, 0.1);
	    var noise = PinkNoise.ar() * noiseAmp;
	    var filter = MoogFF.ar(noise, filterFreq, filterRes);
	    var bitcrush = Decimator.ar(filter, 22050, 8);
            var final = Limiter.ar(Mix.ar([osc1, osc2, osc3, bitcrush]));
            Out.ar(out, final.dup);
        }.play(args: [\out, context.out_b,
	              \osc1Freq, 55,
		      \osc2Freq, 110,
		      \osc3Freq, 220,
                      \oscSlop, 0,
                      \osc1Fb, 0,
                      \osc2Fb, 0,
                      \osc3Fb, 0,
		      \osc1Amp, 0.0,
		      \osc2Amp, 0.0,
		      \osc3Amp, 0.0,
		      \noiseAmp, 0.0,
		      \filterFreq, 65,
		      \filterRes, 1],
             target: context.xg
	);

        this.addCommand("oscSlop", "f", {
            arg msg;
            synth.set(\oscSlop, msg[1]);
        });
        this.addCommand("osc1Freq", "f", {
            arg msg;
            synth.set(\osc1Freq, msg[1]);
        });
        this.addCommand("osc2Freq", "f", {
            arg msg;
            synth.set(\osc2Freq, msg[1]);
        });
        this.addCommand("osc3Freq", "f", {
            arg msg;
            synth.set(\osc3Freq, msg[1]);
        });
        this.addCommand("osc1Fb", "f", {
            arg msg;
            synth.set(\osc1Fb, msg[1]);
        });
        this.addCommand("osc2Fb", "f", {
            arg msg;
            synth.set(\osc2Fb, msg[1]);
        });
        this.addCommand("osc3Fb", "f", {
            arg msg;
            synth.set(\osc3Fb, msg[1]);
        });
        this.addCommand("osc1Amp", "f", {
            arg msg;
            synth.set(\osc1Amp, msg[1]);
        });
        this.addCommand("osc2Amp", "f", {
            arg msg;
            synth.set(\osc2Amp, msg[1]);
        });
        this.addCommand("osc3Amp", "f", {
            arg msg;
            synth.set(\osc3Amp, msg[1]);
        });
        this.addCommand("noiseAmp", "f", {
            arg msg;
            synth.set(\noiseAmp, msg[1]);
        });
        this.addCommand("filterFreq", "f", {
            arg msg;
            synth.set(\filterFreq, msg[1]);
        });
        this.addCommand("filterRes", "f", {
            arg msg;
            synth.set(\filterRes, msg[1]);
        });
    }

    free {
        synth.free;
    }
}
