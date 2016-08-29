# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )
COMMIT="acb02c7c71e353e5dfbc905d506b54908533027e"

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Library for creating and manipulating HTML documents using an elegant DOM API"
HOMEPAGE="https://github.com/Knio/dominate"
# Releases aren't tagged on GitHub, tests are missing from PyPI
# https://github.com/Knio/dominate/pull/69
SRC_URI="https://github.com/Knio/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
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
