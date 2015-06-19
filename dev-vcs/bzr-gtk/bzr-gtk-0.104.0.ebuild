# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/bzr-gtk/bzr-gtk-0.104.0.ebuild,v 1.1 2012/10/08 19:45:54 fauli Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

MY_P="/${P/_rc/rc}"

DESCRIPTION="A GTK+ interfaces to most Bazaar operations"
HOMEPAGE="http://bazaar-vcs.org/bzr-gtk"
SRC_URI="http://launchpad.net/${PN}/gtk3/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome-keyring gpg nautilus"

DEPEND=">=dev-vcs/bzr-1.6_rc1
	dev-python/pygobject
	dev-python/notify-python
	>=dev-python/pycairo-1.0"
RDEPEND="${DEPEND}
	nautilus? ( >=dev-python/nautilus-python-1.0 )
	dev-python/notify-python
	gnome-keyring? ( dev-python/gnome-keyring-python )
	gpg? ( app-crypt/seahorse )"

S="${WORKDIR}/${MY_P}"

#TODO: src_test

src_prepare() {
	cp "${FILESDIR}"/credits.pickle "${S}"/credits.pickle
}

src_install() {
	distutils_src_install
	insinto /etc/xdg/autostart
	doins bzr-notify.desktop
	if ! use nautilus
	then
		rm -rf "${D}"/usr/$(get_libdir)/nautilus/
		rm -rf "${D}"$(python_get_libdir --final-ABI)/site-packages/bzrlib/plugins/gtk/nautilus-bzr.py
	fi
}
