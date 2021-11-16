# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Next generation unittest with plugins"
HOMEPAGE="https://github.com/nose-devs/nose2"
SRC_URI="https://github.com/nose-devs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~sparc x86"

RDEPEND="
	>=dev-python/coverage-4.4.1[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	dev-python/sphinx_rtd_theme

python_test() {
	"${EPYTHON}" -m nose2.__main__ -vv || die "tests failed under ${EPYTHON}"
}
