# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6,3_7} )
inherit distutils-r1

DESCRIPTION="Generate simple tables in terminals from a nested list of strings"
HOMEPAGE="https://robpol86.github.io/terminaltables"
SRC_URI="https://github.com/Robpol86/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/colorama[${PYTHON_USEDEP}]
		dev-python/colorclass[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/termcolor[${PYTHON_USEDEP}]
	)"

python_test() {
	pytest -vv || die "Tests fail with ${EPYTHON}"
}
