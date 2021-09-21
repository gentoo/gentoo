# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

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
	epytest tests
}
