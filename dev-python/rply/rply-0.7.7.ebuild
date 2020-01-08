# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6,3_7} )

inherit distutils-r1

DESCRIPTION="Pure python parser generator that also works with RPython"
HOMEPAGE="https://github.com/alex/rply"
SRC_URI="https://github.com/alex/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/py[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}] )"

python_test() {
	pytest -vv || die "Tests fail with ${EPYTHON}"
}
