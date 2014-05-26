This is a gamepad-controlled laptop instrument created from PS3 controllers, a laptop, a bluetooth adapter (if your system doesn't come with one built in), and the ChucK and Processing languages.

Software Requirements:

miniAudicle 1.3.0a (this is the UI for ChucK)
Chuck: version 1.3.2.0
Processing: version 2.1.2
(for linux BlueTooth connections - see https://help.ubuntu.com/community/Sixaxis for instructions):
sixad - QtSixA Daemon
sixpair- - used for USB Pairing
QtSixA - Sixaxis Joystick Manager



Setup for SAA project:

1) Set up bluetooth devices (linux only - I haven't run this in the Windows or Mac OS)

Start by stopping sixad
Run sixpair for each controller
Run sixad once
Press the (PS) button for each controller
Fire up qtsixa to verify connections

2) Fire up miniAudicle

Run joystick_test.ck in ChucK for each controller
Open the following at a minimum:
  - initialize.ck
  - score.ck
  - Track.ck
  - BaseTrack.ck
Edit score.ck to set controllers to their corresponding controller devices

3) Fire up Processing

Open TrackSequence sketch

4) Start TrackSequence
5) Start initialize.ck
6) Start score.ck


