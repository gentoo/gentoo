# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
GCONF_DEBUG="no"

inherit python-single-r1 gnome2

DESCRIPTION="A password manager for GNOME"
HOMEPAGE="http://revelation.olasagasti.info/"
SRC_URI="https://www.bitbucket.org/erikg/revelation/downloads/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="test"

RDEPEND="${PYTHON_DEPS}
	dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/pycrypto[${PYTHON_USEDEP}]
	dev-python/gconf-python[${PYTHON_USEDEP}]
	dev-python/libgnome-python[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	sys-libs/cracklib[python,${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}"

src_configure() {
	gnome2_src_configure \
		--without-applet \
		--disable-desktop-update \
		--disable-mime-update
}

src_install() {
	gnome2_src_install
	python_fix_shebang "${ED}"
}
