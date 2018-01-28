# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-build

DESCRIPTION="Meta ebuild to pull in gst plugins for apps"
HOMEPAGE="https://www.gentoo.org"

LICENSE="metapackage"
SLOT="1.0"
KEYWORDS="~alpha amd64 ~arm64 hppa ia64 ppc ppc64 x86"
IUSE="aac a52 alsa cdda dts dv dvb dvd ffmpeg flac http jack lame libass libvisual mms mp3 modplug mpeg ogg opus oss pulseaudio taglib theora v4l vaapi vcd vorbis vpx wavpack X x264"
REQUIRED_USE="opus? ( ogg ) theora? ( ogg ) vorbis? ( ogg )"

RDEPEND="
	>=media-libs/gstreamer-${PV}:1.0[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-${PV}:1.0[alsa?,ogg?,theora?,vorbis?,X?,${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-good-${PV}:1.0[${MULTILIB_USEDEP}]
	a52? ( >=media-plugins/gst-plugins-a52dec-${PV}:1.0[${MULTILIB_USEDEP}] )
	aac? ( >=media-plugins/gst-plugins-faad-${PV}:1.0[${MULTILIB_USEDEP}] )
	cdda? ( || (
		>=media-plugins/gst-plugins-cdparanoia-${PV}:1.0[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-cdio-${PV}:1.0[${MULTILIB_USEDEP}] ) )
	dts? ( >=media-plugins/gst-plugins-dts-${PV}:1.0[${MULTILIB_USEDEP}] )
	dv? ( >=media-plugins/gst-plugins-dv-${PV}:1.0[${MULTILIB_USEDEP}] )
	dvb? (
		>=media-plugins/gst-plugins-dvb-${PV}:1.0[${MULTILIB_USEDEP}]
		>=media-libs/gst-plugins-bad-${PV}:1.0[${MULTILIB_USEDEP}] )
	dvd? (
		>=media-libs/gst-plugins-ugly-${PV}:1.0[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-a52dec-${PV}:1.0[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-dvdread-${PV}:1.0[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-mpeg2dec-${PV}:1.0[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-resindvd-${PV}:1.0[${MULTILIB_USEDEP}] )
	ffmpeg? ( >=media-plugins/gst-plugins-libav-${PV}:1.0[${MULTILIB_USEDEP}] )
	flac? ( >=media-plugins/gst-plugins-flac-${PV}:1.0[${MULTILIB_USEDEP}] )
	http? ( >=media-plugins/gst-plugins-soup-${PV}:1.0[${MULTILIB_USEDEP}] )
	jack? ( >=media-plugins/gst-plugins-jack-${PV}:1.0[${MULTILIB_USEDEP}] )
	lame? ( >=media-plugins/gst-plugins-lame-${PV}:1.0[${MULTILIB_USEDEP}] )
	libass? ( >=media-plugins/gst-plugins-assrender-${PV}:1.0[${MULTILIB_USEDEP}] )
	libvisual? ( >=media-plugins/gst-plugins-libvisual-${PV}:1.0[${MULTILIB_USEDEP}] )
	mms? ( >=media-plugins/gst-plugins-libmms-${PV}:1.0[${MULTILIB_USEDEP}] )
	modplug? ( >=media-plugins/gst-plugins-modplug-${PV}:1.0[${MULTILIB_USEDEP}] )
	mp3? (
		>=media-libs/gst-plugins-ugly-${PV}:1.0[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-mpg123-${PV}:1.0[${MULTILIB_USEDEP}] )
	mpeg? ( >=media-plugins/gst-plugins-mpeg2dec-${PV}:1.0[${MULTILIB_USEDEP}] )
	opus? ( >=media-plugins/gst-plugins-opus-${PV}:1.0[${MULTILIB_USEDEP}] )
	oss? ( >=media-plugins/gst-plugins-oss-${PV}:1.0[${MULTILIB_USEDEP}] )
	pulseaudio? ( >=media-plugins/gst-plugins-pulse-${PV}:1.0[${MULTILIB_USEDEP}] )
	taglib? ( >=media-plugins/gst-plugins-taglib-${PV}:1.0[${MULTILIB_USEDEP}] )
	v4l? ( >=media-plugins/gst-plugins-v4l2-${PV}:1.0[${MULTILIB_USEDEP}] )
	vaapi? ( >=media-plugins/gst-plugins-vaapi-${PV}:1.0[${MULTILIB_USEDEP}] )
	vcd? (
		>=media-plugins/gst-plugins-mplex-${PV}:1.0[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-mpeg2dec-${PV}:1.0[${MULTILIB_USEDEP}] )
	vpx? ( >=media-plugins/gst-plugins-vpx-${PV}:1.0[${MULTILIB_USEDEP}] )
	wavpack? ( >=media-plugins/gst-plugins-wavpack-${PV}:1.0[${MULTILIB_USEDEP}] )
	x264? ( >=media-plugins/gst-plugins-x264-${PV}:1.0[${MULTILIB_USEDEP}] )
"

# Usage note:
# The idea is that apps depend on this for optional gstreamer plugins.  Then,
# when USE flags change, no app gets rebuilt, and all apps that can make use of
# the new plugin automatically do.

# When adding deps here, make sure the keywords on the gst-plugin are valid.
