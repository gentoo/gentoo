# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

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
		dev-python/pytest-runner[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
RDEPEND=""

python_test() {
	py.test || die "Tests failed with ${EPYTHON}"
}
