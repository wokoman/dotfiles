import subprocess

def get_firefox_instance():
  return subprocess.check_output('dbus-send --session --dest=org.freedesktop.DBus --type=method_call --print-reply /org/freedesktop/DBus org.freedesktop.DBus.ListNames | grep firefox | awk -F\'"\' \'{print $2}\'',
  shell=True,
  text=True).strip()

def firefox_play_pause():
  return subprocess.Popen('dbus-send --print-reply --dest={} /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause'.format(get_firefox_instance()),
  shell=True)

def firefox_play_next():
  return subprocess.Popen('dbus-send --print-reply --dest={} /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next'.format(get_firefox_instance()),
  shell=True)

def firefox_play_previous():
  return subprocess.Popen('dbus-send --print-reply --dest={} /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous'.format(get_firefox_instance()),
  shell=True)

firefox_play_pause()