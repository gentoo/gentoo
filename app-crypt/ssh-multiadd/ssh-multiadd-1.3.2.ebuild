# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/ssh-multiadd/ssh-multiadd-1.3.2.ebuild,v 1.4 2013/01/22 17:25:07 ago Exp $

EAPI=4

PYTHON_DEPEND="2"

inherit python

DESCRIPTION="Adds multiple ssh keys to the ssh authentication agent"
HOMEPAGE="http://code.fluffytapeworm.com/projects"
SRC_URI="http://code.fluffytapeworm.com/projects/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="X"

DEPEND=""
RDEPEND="X? ( >=net-misc/x11-ssh-askpass-1.2.2 )"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	python_convert_shebangs -r 2 .
}

src_compile(){
	:
}

src_install() {
	dobin ssh-multiadd
	doman ssh-multiadd.1
	dodoc Changelog README todo
}
