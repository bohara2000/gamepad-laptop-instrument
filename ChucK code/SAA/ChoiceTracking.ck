// ChoiceTracking.ck
// Keeps track of which device pressed which button and how many times
// used for driving condition-based automatic tracks
public class ChoiceTracking
{
    // variables
    Controller controllers[7];
    
	// methods
    // add a controller to array of Controller objects
	fun void addController(string deviceName, int deviceNumber)  {
        // instantiate element ;
		new Controller @=> controllers[deviceName]; 
		controllers[deviceName].DeviceNumber = deviceNumber;
    }
	
	// increment count of buttons pressed
	fun void logButtonPress()
	{
	
	}
	
}

class Controller
{
	int => DeviceNumber;
	
	0 => int ACount;
	0 => int BCount;
	0 => int CCount;
	0 => int DCount;
}