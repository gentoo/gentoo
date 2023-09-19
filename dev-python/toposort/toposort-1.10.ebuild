# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Implements a topological sort algorithm"
HOMEPAGE="
	https://gitlab.com/ericvsmith/toposort/
	https://pypi.org/project/toposort/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

python_test() {
	"${EPYTHON}" test/test_toposort.py -v || die "Tests failed with ${EPYTHON}"
}
