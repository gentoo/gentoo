# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{6,7} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Removes unused imports and unused variables as reported by pyflakes"
HOMEPAGE="
	https://github.com/myint/autoflake
	https://pypi.org/project/autoflake
"
SRC_URI="https://github.com/myint/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-python/pyflakes-1.1.0[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

python_test() {
	"${EPYTHON}" test_autoflake.py || die
}
