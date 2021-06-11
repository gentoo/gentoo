# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="2D vector and rectangle classes"
HOMEPAGE="https://github.com/kxgames/vecrec
	https://pypi.org/project/vecrec/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0"

distutils_enable_tests pytest

python_test() {
	pytest -vv tests || die "Tests fail with ${EPYTHON}"
}
