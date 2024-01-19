# DockerMicrophonePassthroughNotes
Notes on how to pass through microphones to docker containers

We're using a random cheap USB sound card, since passing through a system PCM seems to be more complicated:

![random cheap USB sound card](https://i.imgur.com/t2d6uLK.jpeg)

Build the arbitrary docker container:

`sudo docker build . -t reaweb.uk/mictest`

Make sure the sound card *isn't* the current on in use by the host system (probably only an issue on systems with a DE) otherwise it won't work in docker:

![not the current input device in ubuntu](https://i.imgur.com/CbnL1LZ.png)

Then run it:

`sudo docker run -it --entrypoint bash --privileged -v "$(pwd)/passthru:/passthru" reaweb.uk/mictest`

I spent a long time trying to passthrough a single USB device instead of all of them... but even if it appeared it couldn't seem 
to be detected by other software. Using `--privileged` has security implications.

Since we're passing through *all* sound devices we need to work out which is the right one, so we use `arecord -l`:

```
card 0: Audio [ThinkPad USB-C Dock Audio], device 0: USB Audio [USB Audio]
Subdevices: 1/1
Subdevice #0: subdevice #0
card 1: Device [USB Audio Device], device 0: USB Audio [USB Audio]
Subdevices: 1/1
Subdevice #0: subdevice #0
card 2: WEBCAM [GENERAL WEBCAM], device 0: USB Audio [USB Audio]
Subdevices: 0/1
Subdevice #0: subdevice #0
card 3: sofhdadsp [sof-hda-dsp], device 0: HDA Analog (*) []
Subdevices: 1/1
Subdevice #0: subdevice #0
card 3: sofhdadsp [sof-hda-dsp], device 1: HDA Digital (*) []
Subdevices: 1/1
Subdevice #0: subdevice #0
card 3: sofhdadsp [sof-hda-dsp], device 6: DMIC (*) []
Subdevices: 0/1
Subdevice #0: subdevice #0
card 3: sofhdadsp [sof-hda-dsp], device 7: DMIC16kHz (*) []
Subdevices: 1/1
Subdevice #0: subdevice #0
card 4: Device_1 [USB Audio Device], device 0: USB Audio [USB Audio]
Subdevices: 1/1
Subdevice #0: subdevice #0
```

Then make a recording:

`arecord -f S16_LE -r 44100 --device="hw:4,0" card4device.wav`

`"hw:4,0"` refers to the card, then the device from `arecord -l`

Then exit the docker container, copy the file out, change the perms and make sure it works!
