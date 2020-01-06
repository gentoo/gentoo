# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Testing library to create mocks, stubs and fakes"
HOMEPAGE="http://flexmock.readthedocs.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
	"
RDEPEND=""

python_install_all() {
	distutils-r1_python_install_all
	dodoc -r  docs
}

python_test() {
	pytest -vv tests || die "pytest failed"
}
