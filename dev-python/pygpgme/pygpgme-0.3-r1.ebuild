# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )

inherit distutils-r1 flag-o-matic

DESCRIPTION="A Python wrapper for the GPGME library"
HOMEPAGE="https://launchpad.net/pygpgme"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-crypt/gpgme"
RDEPEND="${DEPEND}"

python_configure_all() {
	append-cflags $(gpgme-config --cflags)
}
