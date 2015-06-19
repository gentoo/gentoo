# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-meta/gst-plugins-meta-1.0-r3.ebuild,v 1.2 2015/01/19 10:33:27 jer Exp $

EAPI="5"

inherit multilib-build

DESCRIPTION="Meta ebuild to pull in gst plugins for apps"
HOMEPAGE="http://www.gentoo.org"

LICENSE="metapackage"
SLOT="1.0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE="aac a52 alsa cdda dts dv dvb dvd ffmpeg flac http jack lame libass libvisual mms mp3 modplug mpeg ogg opus oss pulseaudio taglib theora v4l vaapi vcd vorbis vpx wavpack X x264"
REQUIRED_USE="opus? ( ogg ) theora? ( ogg ) vorbis? ( ogg )"

RDEPEND="
	>=media-libs/gstreamer-1.2.3:1.0[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-1.2.3:1.0[alsa?,ogg?,theora?,vorbis?,X?,${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-good-1.2.3:1.0[${MULTILIB_USEDEP}]
	a52? ( >=media-plugins/gst-plugins-a52dec-1.2.3:1.0[${MULTILIB_USEDEP}] )
	aac? ( >=media-plugins/gst-plugins-faad-1.2.3:1.0[${MULTILIB_USEDEP}] )
	cdda? ( || (
		>=media-plugins/gst-plugins-cdparanoia-1.2.3:1.0[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-cdio-1.2.3:1.0[${MULTILIB_USEDEP}] ) )
	dts? ( >=media-plugins/gst-plugins-dts-1.2.3:1.0[${MULTILIB_USEDEP}] )
	dv? ( >=media-plugins/gst-plugins-dv-1.2.3:1.0[${MULTILIB_USEDEP}] )
	dvb? (
		>=media-plugins/gst-plugins-dvb-1.2.3:1.0[${MULTILIB_USEDEP}]
		>=media-libs/gst-plugins-bad-1.2.3:1.0[${MULTILIB_USEDEP}] )
	dvd? (
		>=media-libs/gst-plugins-ugly-1.2.3:1.0[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-a52dec-1.2.3:1.0[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-dvdread-1.2.3:1.0[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-mpeg2dec-1.2.3:1.0[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-resindvd-1.2.3:1.0[${MULTILIB_USEDEP}] )
	ffmpeg? ( >=media-plugins/gst-plugins-libav-1.1.0_pre20130128-r1:1.0[${MULTILIB_USEDEP}] )
	flac? ( >=media-plugins/gst-plugins-flac-1.2.3:1.0[${MULTILIB_USEDEP}] )
	http? ( >=media-plugins/gst-plugins-soup-1.2.3:1.0[${MULTILIB_USEDEP}] )
	jack? ( >=media-plugins/gst-plugins-jack-1.2.3:1.0[${MULTILIB_USEDEP}] )
	lame? ( >=media-plugins/gst-plugins-lame-1.2.3:1.0[${MULTILIB_USEDEP}] )
	libass? ( >=media-plugins/gst-plugins-assrender-1.2.3:1.0[${MULTILIB_USEDEP}] )
	libvisual? ( >=media-plugins/gst-plugins-libvisual-1.2.3:1.0[${MULTILIB_USEDEP}] )
	mms? ( >=media-plugins/gst-plugins-libmms-1.2.3:1.0[${MULTILIB_USEDEP}] )
	modplug? ( >=media-plugins/gst-plugins-modplug-1.2.4-r1:1.0[${MULTILIB_USEDEP}] )
	mp3? (
		>=media-libs/gst-plugins-ugly-1.2.3:1.0[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-mad-1.2.3:1.0[${MULTILIB_USEDEP}] )
	mpeg? ( >=media-plugins/gst-plugins-mpeg2dec-1.2.3:1.0[${MULTILIB_USEDEP}] )
	opus? ( >=media-plugins/gst-plugins-opus-1.2.3:1.0[${MULTILIB_USEDEP}] )
	oss? ( >=media-plugins/gst-plugins-oss-1.2.3:1.0[${MULTILIB_USEDEP}] )
	pulseaudio? ( >=media-plugins/gst-plugins-pulse-1.2.3:1.0[${MULTILIB_USEDEP}] )
	taglib? ( >=media-plugins/gst-plugins-taglib-1.2.3:1.0[${MULTILIB_USEDEP}] )
	v4l? ( >=media-plugins/gst-plugins-v4l2-1.2.3:1.0[${MULTILIB_USEDEP}] )
	vaapi? ( >=media-plugins/gst-plugins-vaapi-0.5.8-r1:1.0[${MULTILIB_USEDEP}] )
	vcd? (
		>=media-plugins/gst-plugins-mplex-1.2.3:1.0[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-mpeg2dec-1.2.3:1.0[${MULTILIB_USEDEP}] )
	vpx? ( >=media-plugins/gst-plugins-vpx-1.2.3:1.0[${MULTILIB_USEDEP}] )
	wavpack? ( >=media-plugins/gst-plugins-wavpack-1.2.3:1.0[${MULTILIB_USEDEP}] )
	x264? ( >=media-plugins/gst-plugins-x264-1.2.3:1.0[${MULTILIB_USEDEP}] )
"

# Usage note:
# The idea is that apps depend on this for optional gstreamer plugins.  Then,
# when USE flags change, no app gets rebuilt, and all apps that can make use of
# the new plugin automatically do.

# When adding deps here, make sure the keywords on the gst-plugin are valid.
