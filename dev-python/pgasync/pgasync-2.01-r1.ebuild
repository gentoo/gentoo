# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="An asynchronous API to PostgreSQL for twisted"
HOMEPAGE="http://www.jamwt.com/pgasync/"
SRC_URI="http://www.jamwt.com/pgasync/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

DEPEND="dev-python/twisted-core[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

DOCS="CHANGELOG PKG-INFO README TODO"

src_install() {
	distutils-r1_python_install_all

	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
