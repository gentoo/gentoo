# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1

DESCRIPTION="A collection of accessible pygments styles"
HOMEPAGE="
	https://pypi.org/project/accessible-pygments/
	https://github.com/Quansight-Labs/accessible-pygments/
"
SRC_URI="
	https://github.com/Quansight-Labs/accessible-pygments/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/pygments-1.5[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${P}-test-install.patch"
)

python_test() {
	# it's more like a demo but at least checks if all themes can
	# be loaded and run; we can't reasonably compare the results
	# because they differ by pygments version a lot
	"${EPYTHON}" test/run_tests.py || die
}
