# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG=no
PYTHON_COMPAT=( python2_7 )

inherit eutils gnome2 multilib python-single-r1

DESCRIPTION="A simple audiofile converter application for the GNOME environment"
HOMEPAGE="http://soundconverter.org/"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="aac flac mp3 opus vorbis"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/gconf-python[${PYTHON_USEDEP}]
	dev-python/gnome-vfs-python[${PYTHON_USEDEP}]
	dev-python/gst-python:0.10[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	>=dev-python/pygtk-2.12[${PYTHON_USEDEP}]
	dev-python/libgnome-python[${PYTHON_USEDEP}]
	gnome-base/libglade[${PYTHON_USEDEP}]
	aac? (
		media-plugins/gst-plugins-faac:0.10
		media-plugins/gst-plugins-faad:0.10 )
	flac? ( media-plugins/gst-plugins-flac:0.10 )
	mp3? (
		media-plugins/gst-plugins-lame:0.10
		media-plugins/gst-plugins-mad:0.10
		media-plugins/gst-plugins-taglib:0.10 )
	vorbis? (
		media-plugins/gst-plugins-ogg:0.10
		media-plugins/gst-plugins-vorbis:0.10 )
	opus? (	media-plugins/gst-plugins-opus:0.10 )
"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext
"

src_prepare() {
	# Fix broken files dropping, upstream bug #1419259
	epatch "${FILESDIR}/${P}-files-dropping.patch"

	python_fix_shebang .
	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	python_optimize "${ED%/}"/usr/$(get_libdir)/soundconverter/python
}
