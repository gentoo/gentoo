# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL="yes"
GCONF_DEBUG="no"

inherit eutils gnome2 distutils-r1

DESCRIPTION="A simple yet powerful multi-track studio"
HOMEPAGE="http://www.jokosher.org"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gnome"

# NOTE: setuptools are a runtime requirement as the app
#       loads its extensions via pkg_resources
RDEPEND="
	dev-python/dbus-python[${PYTHON_USEDEP}]
	>=dev-python/gst-python-0.10.8:0.10[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	>=dev-python/pygtk-2.10[${PYTHON_USEDEP}]
	gnome-base/librsvg
	>=media-libs/gnonlin-0.10.9:0.10
	>=media-libs/gst-plugins-good-0.10.6:0.10
	>=media-libs/gst-plugins-bad-0.10.5:0.10
	>=media-plugins/gst-plugins-alsa-0.10.14:0.10
	>=media-plugins/gst-plugins-flac-0.10.6:0.10
	gnome? ( >=media-plugins/gst-plugins-gnomevfs-0.10.14:0.10 )
	>=media-plugins/gst-plugins-lame-0.10.6:0.10
	>=media-plugins/gst-plugins-ogg-0.10.14:0.10
	>=media-plugins/gst-plugins-vorbis-0.10.14:0.10
	>=media-plugins/gst-plugins-ladspa-0.10.5:0.10
	x11-themes/hicolor-icon-theme
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.11.1-update-database.patch \
		"${FILESDIR}"/${P}-cairo.patch
	gnome2_src_prepare
	distutils-r1_src_prepare
}

src_configure() {
	distutils-r1_src_configure
}

src_compile() {
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
}
