# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit multilib-build

DESCRIPTION="Meta ebuild to pull in gst plugins for apps"
HOMEPAGE="https://www.gentoo.org"

LICENSE="metapackage"
SLOT="0.10"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE="aac a52 alsa cdda dts dv dvb dvd ffmpeg flac http jack lame libass libvisual mms mp3 mpeg musepack ogg opus oss pulseaudio taglib theora v4l vcd vorbis vpx wavpack X x264 xv xvid"
REQUIRED_USE="opus? ( ogg ) theora? ( ogg ) vorbis? ( ogg )"

RDEPEND=">=media-libs/gstreamer-0.10.36-r2:0.10[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-0.10.36:0.10[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-good-0.10.31:0.10[${MULTILIB_USEDEP}]
	a52? ( >=media-plugins/gst-plugins-a52dec-0.10.19:0.10[${MULTILIB_USEDEP}] )
	aac? ( >=media-plugins/gst-plugins-faad-0.10.23:0.10[${MULTILIB_USEDEP}] )
	alsa? ( >=media-plugins/gst-plugins-alsa-0.10.36:0.10[${MULTILIB_USEDEP}] )
	cdda? ( || (
		>=media-plugins/gst-plugins-cdparanoia-0.10.36:0.10[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-cdio-0.10.19:0.10[${MULTILIB_USEDEP}] ) )
	dts? ( >=media-plugins/gst-plugins-dts-0.10.23:0.10[${MULTILIB_USEDEP}] )
	dv? ( >=media-plugins/gst-plugins-dv-0.10.31:0.10[${MULTILIB_USEDEP}] )
	dvb? (
		>=media-plugins/gst-plugins-dvb-0.10.23:0.10[${MULTILIB_USEDEP}]
		>=media-libs/gst-plugins-bad-0.10.23-r1:0.10[${MULTILIB_USEDEP}] )
	dvd? (
		>=media-libs/gst-plugins-ugly-0.10.19:0.10[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-a52dec-0.10.19:0.10[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-dvdread-0.10.19:0.10[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-mpeg2dec-0.10.19:0.10[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-resindvd-0.10.23:0.10[${MULTILIB_USEDEP}] )
	ffmpeg? ( >=media-plugins/gst-plugins-ffmpeg-0.10.13_p201211:0.10[${MULTILIB_USEDEP}] )
	flac? ( >=media-plugins/gst-plugins-flac-0.10.31:0.10[${MULTILIB_USEDEP}] )
	http? ( >=media-plugins/gst-plugins-soup-0.10.31:0.10[${MULTILIB_USEDEP}] )
	jack? ( >=media-plugins/gst-plugins-jack-0.10.31:0.10[${MULTILIB_USEDEP}] )
	lame? ( >=media-plugins/gst-plugins-lame-0.10.19:0.10[${MULTILIB_USEDEP}] )
	libass? ( >=media-plugins/gst-plugins-assrender-0.10.23:0.10[${MULTILIB_USEDEP}] )
	libvisual? ( >=media-plugins/gst-plugins-libvisual-0.10.36:0.10[${MULTILIB_USEDEP}] )
	mms? ( >=media-plugins/gst-plugins-libmms-0.10.23:0.10[${MULTILIB_USEDEP}] )
	mp3? (
		>=media-libs/gst-plugins-ugly-0.10.19:0.10[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-mad-0.10.19:0.10[${MULTILIB_USEDEP}] )
	mpeg? ( >=media-plugins/gst-plugins-mpeg2dec-0.10.19:0.10[${MULTILIB_USEDEP}] )
	musepack? ( >=media-plugins/gst-plugins-musepack-0.10.23:0.10[${MULTILIB_USEDEP}] )
	ogg? ( >=media-plugins/gst-plugins-ogg-0.10.36:0.10[${MULTILIB_USEDEP}] )
	opus? ( >=media-plugins/gst-plugins-opus-0.10.23:0.10[${MULTILIB_USEDEP}] )
	oss? ( >=media-plugins/gst-plugins-oss-0.10.31:0.10[${MULTILIB_USEDEP}] )
	pulseaudio? ( >=media-plugins/gst-plugins-pulse-0.10.31:0.10[${MULTILIB_USEDEP}] )
	theora? ( >=media-plugins/gst-plugins-theora-0.10.36-r1:0.10[${MULTILIB_USEDEP}] )
	taglib? ( >=media-plugins/gst-plugins-taglib-0.10.31:0.10[${MULTILIB_USEDEP}] )
	v4l? ( >=media-plugins/gst-plugins-v4l2-0.10.31:0.10[${MULTILIB_USEDEP}] )
	vcd? (
		>=media-plugins/gst-plugins-mplex-0.10.23:0.10[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-mpeg2dec-0.10.19:0.10[${MULTILIB_USEDEP}] )
	vorbis? ( >=media-plugins/gst-plugins-vorbis-0.10.36:0.10[${MULTILIB_USEDEP}] )
	vpx? ( >=media-plugins/gst-plugins-vp8-0.10.23-r1:0.10[${MULTILIB_USEDEP}] )
	wavpack? ( >=media-plugins/gst-plugins-wavpack-0.10.31:0.10[${MULTILIB_USEDEP}] )
	X? ( >=media-plugins/gst-plugins-x-0.10.36:0.10[${MULTILIB_USEDEP}] )
	x264? ( >=media-plugins/gst-plugins-x264-0.10.19:0.10[${MULTILIB_USEDEP}] )
	xv? ( >=media-plugins/gst-plugins-xvideo-0.10.36:0.10[${MULTILIB_USEDEP}] )
	xvid? ( >=media-plugins/gst-plugins-xvid-0.10.23:0.10[${MULTILIB_USEDEP}] )"

# Usage note:
# The idea is that apps depend on this for optional gstreamer plugins.  Then,
# when USE flags change, no app gets rebuilt, and all apps that can make use of
# the new plugin automatically do.

# When adding deps here, make sure the keywords on the gst-plugin are valid.
