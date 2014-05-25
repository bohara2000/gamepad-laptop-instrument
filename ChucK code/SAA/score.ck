// score.ck
// on the fly drumming with global BPM conducting
BPM bpm;
bpm.tempo(80.0);

<<< "Creating tracks" >>>;
Track track1;
Track track2;
Track track3;
Track track4;
Track track5;
Track track6;
Track track7;

<<< "Setting beat patterns" >>>;
// [4,4,2]
[ bpm.quarterNote, bpm.quarterNote, bpm.quarterNote*2 ] @=> dur BeatPattern1[];
track1.SetBeat( BeatPattern1 );
// [4,4,4]
[ bpm.quarterNote, bpm.quarterNote, bpm.quarterNote, bpm.quarterNote ] @=> dur BeatPattern2[];
track2.SetBeat( BeatPattern2 );
// [4,8,8,4,16,16,16,16]
[ bpm.quarterNote, bpm.eighthNote, bpm.eighthNote, bpm.quarterNote, bpm.sixteenthNote, bpm.sixteenthNote, bpm.sixteenthNote, bpm.sixteenthNote ] @=> dur BeatPattern3[];
track3.SetBeat( BeatPattern3 );
[ bpm.quarterNote, bpm.eighthNote, bpm.eighthNote, bpm.quarterNote, bpm.sixteenthNote, bpm.sixteenthNote, bpm.sixteenthNote, bpm.sixteenthNote ] @=> dur BeatPattern4[];
track4.SetBeat( BeatPattern4 );
// [2,4,4]
[ bpm.quarterNote*2, bpm.quarterNote, bpm.quarterNote ] @=> dur BeatPattern5[];
track5.SetBeat( BeatPattern5 );
//[8,8,4,4]
[ bpm.eighthNote, bpm.eighthNote, bpm.quarterNote, bpm.eighthNote, bpm.eighthNote, bpm.quarterNote ] @=> dur BeatPattern6[];
//track6.SetBeat( BeatPattern6 );
// [4,4,2]
[ bpm.quarterNote, bpm.quarterNote, bpm.quarterNote*2 ] @=> dur BeatPattern7[];
//track7.SetBeat( BeatPattern7 );

track2.ChangeClick(me.dir() + "/sounds/click_02.wav");
track3.ChangeClick(me.dir() + "/sounds/click_02.wav");

track4.ChangeClick(me.dir() + "/sounds/click_03.wav");
track5.ChangeClick(me.dir() + "/sounds/click_03.wav");

//track6.ChangeClick(me.dir() + "/sounds/click_04.wav");
//track7.ChangeClick(me.dir() + "/sounds/click_05.wav");

<<< "Define samples for each track" >>>;
[ "Gamelon1_f.wav", "Gamelon2_f.wav", "Gamelon5_f.wav", "Gamelon6_f.wav" ] @=> string set1[];
[ "kick01.wav", "snare01.wav", "hihat_closed01.wav", "hihat_opened01.wav" ] @=> string set2[];
[ "58713__arioke__kalimba-lam09-bb3-tip-soft.wav", "58716__arioke__kalimba-lam11-d4-tip-med.wav", "58732__arioke__kalimba-lam08-a3-wipe-med.wav", "58736__arioke__kalimba-lam10-c4-wipe-med.wav" ] @=> string set3[];
[ "96132__bmaczero__bing1.wav", "96133__bmaczero__bong1.wav", "103631__benboncan__large-anvil-steel-hammer-3.wav", "132997__cosmicd__construction-slap.wav" ] @=> string set4[];
[ "11126__jnr-hacksaw__deep-drip-hit.wav", "125693__connersaw8__square-sweep-up.wav", "187025__lloydevans09__jump1.wav", "233756__szpury__weird-hit-wide-spectrum-002-001.wav" ] @=> string set5[];
[ "106924__bubaproducer__17.wav", "150933__yikitama__wubbadubba.wav", "157219__adamweeden__video-game-gain-coin.wav", "211741__taira-komori__jump01.wav" ] @=> string set6[];
/*





[ "Gamelon1_f.wav", "Gamelon2_f.wav", "Gamelon5_f.wav", "Gamelon6_f.wav" ] @=> string set7[];
*/

<<< "Set sample collections for each track" >>>;
track1.PopulateSamplesBySet(1, set1);
track2.PopulateSamplesBySet(2, set2);
track3.PopulateSamplesBySet(3, set3);
track4.PopulateSamplesBySet(4, set4);
track5.PopulateSamplesBySet(5, set5);
//track6.PopulateSamplesBySet(6, set6);
/*
track7.PopulateSamplesBySet(7, set7);
*/

<<< "Create the AutoTrack instance(s)" >>>;
//AutoTrack autotrack1;

<<< "Begin recording" >>>;

<<< "Begin playing" >>>;
spork ~ track1.StartTrack();
spork ~ track2.StartTrack();
spork ~ track3.StartTrack();
spork ~ track4.StartTrack();
spork ~ track5.StartTrack();
//spork ~ track6.StartTrack();
//spork ~ track7.StartTrack();

spork ~ track1.StartMetronome();
spork ~ track2.StartMetronome();
spork ~ track3.StartMetronome();
spork ~ track4.StartMetronome();
spork ~ track5.StartMetronome();
//spork ~ track6.StartMetronome();
//spork ~ track7.StartMetronome();

<<< "Search for controllers. Assign each one to a track" >>>;
track1.SetController(0);
/*
track2.SetController(1);
track3.SetController(2);
track4.SetController(3);
track5.SetController(4);
*/
//track6.SetController(5);

/*

track4.SetController(3);
track5.SetController(4);
track6.SetController(5);
track7.SetController(6);
*/

0 => track1.TrackID;
1 => track2.TrackID;
2 => track3.TrackID;
3 => track4.TrackID;
4 => track5.TrackID;
//5 => track6.TrackID;

Machine.add(me.dir()+"/rec-auto-stereo.ck");

spork ~ track1.Play();
spork ~ track2.Play();
spork ~ track3.Play();
spork ~ track4.Play();
spork ~ track5.Play();
//spork ~ track6.Play();
//spork ~ track7.Play();
/*

spork ~ track4.Play();
spork ~ track5.Play();
spork ~ track6.Play();
spork ~ track7.Play();
*/

<<< "End playing after certain duration - or when you say stop." >>>;

while(true)
{
    10::ms => now;
}
