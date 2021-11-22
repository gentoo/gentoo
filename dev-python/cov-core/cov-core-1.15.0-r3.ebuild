# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="plugin core for use by pytest-cov, nose-cov and nose2-cov"
HOMEPAGE="https://github.com/schlamar/cov-core"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND=">=dev-python/coverage-3.6[${PYTHON_USEDEP}]"

python_install() {
	[[ ${EPYTHON} == pypy* ]] && addpredict "$(python_get_sitedir)/init_cov_core.pth"
	distutils-r1_python_install
}

python_install_all() {
	distutils-r1_python_install_all
	find "${D}" -name '*.pth' -delete || die
}
