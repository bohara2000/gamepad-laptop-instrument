public class SoundChain
{
    // sound chain
    // master gain object
    Gain master => JCRev r => dac;

    0.25 => r.mix;
        
}