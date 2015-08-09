# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit eutils multilib python-single-r1

DESCRIPTION="A music management and playback for GTK+ based desktops"
HOMEPAGE="http://www.listen-project.org/"
SRC_URI="http://download.listen-project.org/${PV%.*}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cdda"

RDEPEND="${PYTHON_DEPS}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/gst-python:0.10[${PYTHON_USEDEP}]
	>=dev-python/pygtk-2.8:2[${PYTHON_USEDEP}]
	dev-python/pyinotify[${PYTHON_USEDEP}]
	|| ( dev-python/python-xlib[${PYTHON_USEDEP}] dev-python/egg-python[${PYTHON_USEDEP}] )
	dev-python/pywebkitgtk
	dev-python/pyxdg[${PYTHON_USEDEP}]
	media-libs/libgpod[python]
	media-libs/mutagen[${PYTHON_USEDEP}]
	media-plugins/gst-plugins-meta:0.10
	x11-libs/libnotify
	cdda? ( dev-python/python-musicbrainz[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	app-text/docbook2X
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	!media-radio/ax25-apps"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-Makefile.patch
	sed -i -e 's:audip/mp3:audio/mp3:' misc/listen.desktop.in || die
}

src_compile() {
	CHECK_DEPENDS=0 emake PYTHON="${EPYTHON}"
}

src_test() { :; } #324719

src_install() {
	DESTDIR="${D}" LIBDIR="/usr/$(get_libdir)" emake install
	dodoc README

	python_optimize "${ED}"/usr/$(get_libdir)/${PN}
}
