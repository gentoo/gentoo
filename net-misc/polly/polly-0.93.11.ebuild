# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE=( gdbm )

inherit distutils-r1 gnome2-utils vcs-snapshot

DESCRIPTION="twitter client designed for multiple columns of multiple accounts"
HOMEPAGE="https://launchpad.net/polly"
SRC_URI="https://launchpad.net/${PN}/1.0/pre-alpha-2/+download/Polly-${PV}%20%28pre-alpha%203.11%29.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-NC-SA-3.0 GPL-2 GPL-3+ MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/gconf-python[${PYTHON_USEDEP}]
	dev-python/gtkspell-python[${PYTHON_USEDEP}]
	dev-python/httplib2[${PYTHON_USEDEP}]
	dev-python/keyring[${PYTHON_USEDEP}]
	dev-python/notify-python[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/oauth2[${PYTHON_USEDEP}]
	dev-python/pycurl[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/socksipy[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

python_prepare_all() {
	rm -rf external/keyring || die
	distutils-r1_python_prepare_all
}

pkg_preinst() {
	gnome2_gconf_savelist
}

pkg_postinst() {
	gnome2_gconf_install
}

pkg_postrm() {
	gnome2_gconf_uninstall
}
