# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/etc-proposals/etc-proposals-1.4.3-r2.ebuild,v 1.5 2011/01/15 16:00:40 maekke Exp $

EAPI=3

PYTHON_DEPEND="2:2.5"

inherit distutils

DESCRIPTION="a set of tools for updating gentoo config files"
HOMEPAGE="http://developer.berlios.de/projects/etc-proposals/"
SRC_URI="mirror://berlios/${PN}/${P}.tar.gz"

IUSE="gtk qt4"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"

DEPEND="gtk? ( >=dev-python/pygtk-2.10 )
		qt4? ( >=dev-python/PyQt4-4.1.1[X] )"
RDEPEND="${DEPEND}"

PYTHON_MODNAME="etcproposals"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_install(){
	distutils_src_install
	dosbin "${D}"/usr/bin/etc-proposals
	rm -rf "${D}"/usr/bin

	# Bug 308725: Filter out the "PreferedFrontends" based on USE Flags:
	use qt4 || sed -i -e '/^PreferedFrontends=/ s/qt4,//' "${D}"/etc/etc-proposals.conf
	use gtk || sed -i -e '/^PreferedFrontends=/ s/gtk2,//' "${D}"/etc/etc-proposals.conf
}

pkg_postinst() {
	distutils_pkg_postinst
	elog "The configuration file has been installed to /etc/etc-proposals.conf"
	elog "If you are installing etc-proposals for the first time or updating"
	elog "from a version < 1.3 you should run the following command once:"
	elog "etc-proposals --init-db"
	ewarn "A full backup of /etc and other files managed by CONFIG_PROTECT"
	ewarn "is highly advised before testing this tool!"
}
