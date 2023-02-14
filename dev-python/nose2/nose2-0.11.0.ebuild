# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1

DESCRIPTION="Next generation unittest with plugins"
HOMEPAGE="https://github.com/nose-devs/nose2"
SRC_URI="https://github.com/nose-devs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc x86"

RDEPEND="
	>=dev-python/coverage-4.4.1[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme

python_test() {
	"${EPYTHON}" -m nose2.__main__ -vv || die "tests failed under ${EPYTHON}"
}
