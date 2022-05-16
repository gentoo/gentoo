# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Implements a topological sort algorithm"
HOMEPAGE="https://gitlab.com/ericvsmith/toposort"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

python_test() {
	"${EPYTHON}" test/test_toposort.py -v || die "Tests failed with ${EPYTHON}"
}
