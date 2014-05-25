public class BaseTrack
{
    // master soundchain
    SoundChain soundchain;
    // BPM class maintains tempo
    BPM Tempo;
    
    // Track ID
    int TrackID;
    
    // declare an array of durations (start with 4/4)
    [ Tempo.quarterNote, Tempo.quarterNote, Tempo.quarterNote, Tempo.quarterNote ] @=> dur BeatPattern[];
    
    // declare SndBuf object to use as click in a metronome
    SndBuf click;
    click => soundchain.master;
    me.dir() + "/sounds/click_01.wav" => click.read;
    click.samples() => click.pos;
    
    // an initial array of four SndBuf objects to use as musical samples
    SndBuf SampleCollection[4];
    
    
    // create a null reference to an instrument
    UGen @ instrument;
    
    // indicates whether to begin playing
    1 => int Playing;
    
    /* OSC properties */
    
    // host name and port
    "localhost" => string hostname;
    6450 => int port;
    
    
    // send object
    OscSend xmit;
    // aim the transmitter
    xmit.setHost( hostname, port );
    
    /*
        NOTE: derived classes must define their own 
        ways of sending messages.
    */
    
    
    /* ************* 
        Methods        
    ************* */
    
    // populate sample collection
    
    fun void PopulateSamplesBySet( int setNumber, string sampleNames[] )
    {
        for ( 0 => int i; i < sampleNames.cap(); i++ )
        {
            <<< "Setting sample:", me.dir() + "/sounds/set" + setNumber + "/" + sampleNames[i] >>>;
            SampleCollection[i] => soundchain.master;
            me.dir() + "/sounds/set" + setNumber + "/" + sampleNames[i] => SampleCollection[i].read;
            SampleCollection[i].samples() => SampleCollection[i].pos;
        }
    }

    fun void ChangeClick(string soundfilePath)
    {
        soundfilePath => click.read;
        click.samples() => click.pos;
    }

    // play clicks according to beat pattern
    fun void StartMetronome() 
    {
        <<< "Metronome started..." >>>;
        while( Playing )
        {
            for ( 0 => int i; i < BeatPattern.cap(); i++ )
            {
                0 => click.pos;
                0.25 => click.gain;
                
                // build and then send OSC message to create Track UI in Processing
                xmit.startMsg("/track/click", "ifi");
                xmit.addInt(TrackID);
                xmit.addFloat(BeatPattern[i]/ms);
                xmit.addInt(i);

                BeatPattern[i] => now;
            }
        }       
    }
    
    fun void SetOSCTransmitPort( int portNumber )
    {
        portNumber => port;
    }
       
}
