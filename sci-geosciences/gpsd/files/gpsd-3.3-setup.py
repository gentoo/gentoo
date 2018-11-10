from distutils.core import setup, Extension

setup(
	name = "gps",
	version = @VERSION@,
	description = 'Python libraries for the gpsd service daemon',
	url = @URL@,
	author = 'the GPSD project',
	author_email = @EMAIL@,
	license = "BSD",
	ext_modules=[
		Extension("gps.packet", @GPS_PACKET_SOURCES@, include_dirs=["."]),
		Extension("gps.clienthelpers", @GPS_CLIENT_SOURCES@, include_dirs=["."]),
	],
	packages = ['gps'],
	scripts = @SCRIPTS@,
)
