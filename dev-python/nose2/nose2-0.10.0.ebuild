# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1

DESCRIPTION="Next generation unittest with plugins"
HOMEPAGE="https://github.com/nose-devs/nose2"
SRC_URI="https://github.com/nose-devs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
# Failures need investigating
RESTRICT="test"

BDEPEND="
	doc? ( >=dev-python/sphinx-1.0.5 )
"
DEPEND="
	>=dev-python/coverage-4.4.1[${PYTHON_USEDEP}]
	>=dev-python/six-1.1[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	"${PYTHON}" -m nose2.__main__ || die "tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )

	distutils-r1_python_install_all
}
