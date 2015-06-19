# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-activity-journal/gnome-activity-journal-0.8.0-r5.ebuild,v 1.4 2015/04/08 17:56:30 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
DISTUTILS_IN_SOURCE_BUILD=true
DISTUTILS_SINGLE_IMPL=true

inherit eutils gnome2 distutils-r1 versionator

DIR_PV=$(get_version_component_range 1-2)

DESCRIPTION="Tool for easily browsing and finding files on your computer"
HOMEPAGE="https://launchpad.net/gnome-activity-journal/"
SRC_URI="http://launchpad.net/gnome-activity-journal/${DIR_PV}/${PV}/+download/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3 LGPL-3"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-python/dbus-python
	dev-python/libgnome-python
	dev-python/gconf-python
	dev-python/gst-python:0.10
	dev-python/pycairo
	dev-python/pygobject:2
	dev-python/pygtk:2
	dev-python/pyxdg
	gnome-extra/zeitgeist
	sys-apps/dbus"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-python/python-distutils-extra"

PATCHES=( "${FILESDIR}"/${P}-zg-0.9.patch )

src_configure() {
	distutils-r1_src_configure
}

src_compile() {
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
	python_fix_shebang "${ED}"
}
