# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 python3_7 python3_8 )
inherit distutils-r1

DESCRIPTION="A collection of fancy functional tools focused on practicality"
HOMEPAGE="https://github.com/Suor/funcy"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	${RDEPEND}
	test? (
		dev-python/whatever[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

python_test() {
	distutils_install_for_testing --via-root
	pytest || die "Tests fail with ${EPYTHON}"
}
