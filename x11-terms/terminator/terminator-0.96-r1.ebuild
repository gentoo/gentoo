# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

PYTHON_DEPEND="2"
PYTHON_MODNAME="terminatorlib"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit gnome2 distutils eutils

DESCRIPTION="Multiple GNOME terminals in one window"
HOMEPAGE="http://www.tenshu.net/p/terminator.html"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="dbus gnome +libnotify"

RDEPEND="
	dev-libs/keybinder:0[python]
	x11-libs/vte:0[python]
	dbus? ( sys-apps/dbus )
	gnome? (
		dev-python/gconf-python
		dev-python/libgnome-python
		dev-python/pygobject:2
		dev-python/pygtk:2
		)
	libnotify? ( dev-python/notify-python )"
DEPEND="dev-util/intltool"

src_prepare() {
	epatch \
		"${FILESDIR}"/0.90-without-icon-cache.patch \
		"${FILESDIR}"/0.94-session.patch
	distutils_src_prepare
}

src_configure() { :; }

pkg_postinst() {
	gnome2_pkg_postinst
	distutils_pkg_postinst
}

pkg_postrm() {
	gnome2_pkg_postrm
	distutils_pkg_postrm
}
