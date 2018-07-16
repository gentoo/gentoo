# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( pypy{,3} python{2_7,3_{4,5,6}} )

inherit distutils-r1

DESCRIPTION="A tiny pythonic visitor implementation"
HOMEPAGE="https://github.com/mbr/visitor"
# PyPI tarballs don't include tests
# https://github.com/mbr/visitor/pull/2
SRC_URI="https://github.com/mbr/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
RDEPEND=""

python_test() {
	py.test || die "Tests failed with ${EPYTHON}"
}
