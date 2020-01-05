# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )

inherit gnome2 python-single-r1

DESCRIPTION="A simple audiofile converter application for the GNOME environment"
HOMEPAGE="https://soundconverter.org/"
MY_PV="${PV/_/-}"
SRC_URI="https://launchpad.net/${PN}/trunk/${MY_PV}/+download/${PN}-${MY_PV}.tar.xz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="aac flac libnotify mp3 ogg opus vorbis"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="${PYTHON_DEPS}
	dev-libs/gobject-introspection:=
	x11-libs/gtk+:3[introspection]
	media-libs/gstreamer:1.0[introspection]
"

# gst-plugins-meta for any decoders, USE flags for specific encoders used by code
# List in soundconverter/gstreamer.py
# wavenc and mp4mux come from gst-plugins-good, which everyone having base should have, so unconditional
RDEPEND="${COMMON_DEPEND}
	x11-libs/pango[introspection]
	dev-python/gst-python:1.0[${PYTHON_USEDEP}]
	libnotify? ( x11-libs/libnotify[introspection] )

	media-libs/gst-plugins-base:1.0[vorbis?,ogg?]
	media-plugins/gst-plugins-meta:1.0
	flac? ( media-plugins/gst-plugins-flac:1.0 )
	media-libs/gst-plugins-good:1.0
	mp3? (
		media-libs/gst-plugins-bad:1.0
		media-libs/gst-plugins-ugly:1.0
		media-plugins/gst-plugins-lame:1.0
	)
	aac? ( media-plugins/gst-plugins-faac:1.0 )
	opus? (	media-plugins/gst-plugins-opus:1.0 )
"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	sys-devel/gettext
"

RESTRICT="test" # broken pot files list in 3.0.0 release, making src_test fallback to "make test" which fails

src_prepare() {
	python_fix_shebang .
	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	python_optimize "${ED%/}"/usr/$(get_libdir)/soundconverter/python
}
