# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/cytoolz/cytoolz-0.7.1.ebuild,v 1.4 2015/03/08 23:43:00 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Cython implementation of Toolz: High performance functional utilities"
HOMEPAGE="https://pypi.python.org/pypi/cytoolz"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-python/cython[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

python_compile() {
	python_is_python3 || local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"

	distutils-r1_python_compile
}
