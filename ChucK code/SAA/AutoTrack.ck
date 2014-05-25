// AutoTrack.ck
// This is an audio track that is driven by conditions produced from an outside source
// It is a subclass of BaseTrack, so it, too, can contain
// - a set of samples; or
// - one or more instruments/effects
public class AutoTrack extends BaseTrack
{
    /* variables */
    
    // flag to determine when to play an AutoTrack
    //int Playing;
    
    /*
    
    methods used for playing automatically
   
    */
    
    // play a sample on a specific beat number
    fun void PlaySampleOnBeat(int BeatNumber)
    {
        <<< "PlaySampleOnBeat, BeatNumber: ", BeatNumber, "Play Indicator: ", Playing >>>;
        /**/
        while ( Playing )
        {
            for ( 0 => int i; i < BeatPattern.cap(); i++ )
            {
                if ( i == BeatNumber)
                {
                    // play some sample here
                    /*
                    0 => click.pos;
                    0.25 => click.gain;
                    BeatPattern[i] => now;
                    */
                }
            }
        }
        
        
    }
    
    fun void PlaySampleWhenChoicePressedNTimes(string Choice, int NumberOfTimesPressed) 
    {
         <<< "PlaySampleWhenChoicePressedNTimes, Choice: ", Choice, "Number Of Times Pressed: ", NumberOfTimesPressed, "Play Indicator: ", Playing >>>;
        /**/        
        while ( Playing )
        {
            for ( 0 => int i; i < BeatPattern.cap(); i++ )
            {
                // figure this one out
            }
        }
        
       
    }
    
    fun void StartTrack()
    {
        <<< "Starting AutoTrack..." >>>;
    }
    
}