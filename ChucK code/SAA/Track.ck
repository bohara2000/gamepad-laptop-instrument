// Track.ck
// This is an audio track
// Can contain
// - a set of samples; or
// - one or more instruments/effects
// Each Track is controlled by a single controller
public class Track extends BaseTrack
{
    // variables
    int TrackBeat[BeatPattern.cap()];
    
    string OSCBeatFormat;
    for ( 0 => int i; i < BeatPattern.cap(); i++){ "f" +=> OSCBeatFormat; }
    
    // make HidIn and HidMsg
    Hid hi;
    HidMsg msg;

    // which joystick
    //0 => int device;
    // get from command line
    //if( me.args() ) me.arg(0) => Std.atoi => device;
    
    // type of input device used ("none", "joystick", "keyboard", "mouse")
    "none" => string deviceType;
    
    // indicates wheather a choice has been selected.
    false => int choiceMade;
    
    // indicates buttonNumber pressed
    int whichButton;
    
    // tracks number of beats in the track that have been 
    // filled in
    int numberOfBeatsSelected;
    
    fun void SetController(int DeviceNumber)
    {
        // set joystick
        //0 => int device;
        
        // open joystick 0, exit on fail
        if( !hi.openJoystick( DeviceNumber ) )
        {
            <<< "There is no controller on Device #'" + DeviceNumber >>>;
        } else {
            "joystick" => deviceType;
            DeviceNumber => TrackID;
            <<< "joystick '" + hi.name() + "' ready", "" >>>;
        }        
    }
    
    fun void SetKeyboard(int DeviceNumber)
    {
        // set joystick
        //0 => int device;
        
        // open joystick 0, exit on fail
        if( !hi.openKeyboard( DeviceNumber ) )
        {
            <<< "There is no keyboard on Device #'" + DeviceNumber >>>;
        } else {
            "keyboard" => deviceType;
            DeviceNumber => TrackID;
            <<< "keyboard '" + hi.name() + "' ready", "" >>>;
        }        
    }
    
    fun void SetMouse(int DeviceNumber)
    {
        // set joystick
        //0 => int device;
        
        // open joystick 0, exit on fail
        if( !hi.openMouse( DeviceNumber ) )
        {
            <<< "There is no mouse on Device #'" + DeviceNumber >>>;
        } else {
            "mouse" => deviceType;
            DeviceNumber => TrackID;
            <<< "mouse '" + hi.name() + "' ready", "" >>>;
        }        
    }
    
    fun void SetBeat( dur NewBeat[] )
    {
        NewBeat @=> BeatPattern;
        TrackBeat.size(BeatPattern.cap());
        "" => OSCBeatFormat;
        for ( 0 => int i; i < BeatPattern.cap(); i++){ "f" +=> OSCBeatFormat; }
    }
    
    fun void Play()
    {
        for ( 0 => int i; i < BeatPattern.cap(); i++ )
        {
            -1 => TrackBeat[i];
        }
        
        while ( Playing )
         {
            0.5 => soundchain.master.gain;
             
            for ( 0 => int i; i < BeatPattern.cap(); i++ )
            {
                <<< "playing beat:", i >>>;                                
                xmit.startMsg( "/track/pulse", "iii" );
                TrackID => xmit.addInt;                      
                i =>  xmit.addInt;
                TrackBeat[i] => xmit.addInt;
                if (TrackBeat[i] >= 0 )
                {
                  <<< "sample exists" >>>;
                    
                    
                    0 => SampleCollection[ TrackBeat[i] ].pos;
                    
                    //0.5 => SampleCollection[ TrackBeat[i] ].gain;
                }
              
                
                if ( (whichButton >= 12 )  && choiceMade )
                {
                    if ( whichButton % 4 == TrackBeat[i])
                    {
                        -1 => TrackBeat[i];
                        numberOfBeatsSelected--;
                    } else {
                        <<< "picking sample", whichButton % 4, "from SampleCollection" >>>;
                        whichButton % 4 => TrackBeat[i];
                        numberOfBeatsSelected++;
                        <<< "sample size = ", SampleCollection[ TrackBeat[i] ].samples() >>>;
                    }
                    
                    // reduce click volume if more than 2/3 of the track is filled out.
                    if ( numberOfBeatsSelected/TrackBeat.cap() >= 0.666 )
                    {
                        0.125 => click.gain;
                    } else {
                        0.25 => click.gain;
                    }
                    false => choiceMade;
                }

                
                BeatPattern[i] => now;
            }
         }
         
         
    }
    
    fun void StartTrack()
    {
        // build and then send OSC message to create Track UI in Processing
        xmit.startMsg("/track/create", "i" + OSCBeatFormat);
        xmit.addInt(hi.num());
        for ( 0 => int i; i < BeatPattern.cap(); i++)
        { 
            xmit.addFloat(BeatPattern[i]/ms);
        }
        
        // infinite event loop
        while( true )
        {
            // wait on HidIn as event
            hi => now;

            // messages received
            while( hi.recv( msg ) )
            {            
                
                /*
                    if on one of the four right joystick button is pressed down,
                    assign a specific sample to the current duration in the BeatPattern array
                */            
                if( msg.isButtonDown() )
                {
                    <<< "joystick button", msg.which , "down" >>>;
                    //false => choiceMade;
                    msg.which => whichButton;
                   
                }
                
                /*
                    joystick button up
                */
                
                else if( msg.isButtonUp() )
                {
                    <<< "joystick button", msg.which, "up" >>>;
                    true => choiceMade;
                }
                
                // joystick hat/POV switch/d-pad motion
                else if( msg.isHatMotion() )
                {
                    <<< "joystick hat", msg.which, ":", msg.idata >>>;
                }
            }
        }
    }
}