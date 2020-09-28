volumeSound = 0.6
volumeMusic = 1

function playSoundEffect(index) {
	audio_play_sound(index, 0, false)
	audio_sound_gain(index, volumeSound, 0)
	debug.log("Playing sound: " + string_upper(string(audio_get_name(index))))
}

music = music_village_interior
//audio_play_sound(music, 0, true)
//audio_sound_gain(music, volumeMusic, 0)