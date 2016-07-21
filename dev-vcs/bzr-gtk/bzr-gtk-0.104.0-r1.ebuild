# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_P="/${P/_rc/rc}"

DESCRIPTION="A GTK+ interfaces to most Bazaar operations"
HOMEPAGE="http://bazaar-vcs.org/bzr-gtk"
SRC_URI="https://launchpad.net/${PN}/gtk3/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome-keyring gpg nautilus"

DEPEND=">=dev-vcs/bzr-1.6_rc1[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/notify-python[${PYTHON_USEDEP}]
	>=dev-python/pycairo-1.0[${PYTHON_USEDEP}]
	nautilus? (
		>=dev-python/nautilus-python-1.0[${PYTHON_USEDEP}]
		virtual/pkgconfig
	)"
RDEPEND="${DEPEND}
	nautilus? ( >=dev-python/nautilus-python-1.0[${PYTHON_USEDEP}] )
	dev-python/notify-python[${PYTHON_USEDEP}]
	gnome-keyring? ( dev-python/gnome-keyring-python[${PYTHON_USEDEP}] )
	gpg? ( app-crypt/seahorse )"

S="${WORKDIR}/${MY_P}"

#TODO: src_test

python_prepare_all() {
	cp "${FILESDIR}"/credits.pickle "${S}"/credits.pickle || die

	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install

	if ! use nautilus; then
		# automagic dep
		rm -rf "${D%/}"/usr/$(get_libdir)/nautilus/ || die
		rm -rf "${D%/}"$(python_get_sitedir)/bzrlib/plugins/gtk/nautilus-bzr.py* || die
	fi
}

python_install_all() {
	distutils-r1_python_install_all

	insinto /etc/xdg/autostart
	doins bzr-notify.desktop
}
