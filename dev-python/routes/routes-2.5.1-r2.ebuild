# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="A re-implementation of Rails routes system, mapping URLs to Controllers/Actions"
HOMEPAGE="
	https://routes.readthedocs.io/en/latest/
	https://github.com/bbangert/routes/
	https://pypi.org/project/Routes/
"
SRC_URI="
	https://github.com/bbangert/routes/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	https://github.com/bbangert/routes/pull/107.patch
		-> ${P}-pytest.patch
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

RDEPEND="
	>=dev-python/repoze-lru-0.3[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/webob[${PYTHON_USEDEP}]
		dev-python/webtest[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

PATCHES=(
	"${DISTDIR}/${P}-pytest.patch"
)

src_prepare() {
	distutils-r1_src_prepare
	# fix the version number
	sed -i -e '/tag/d' setup.cfg || die
	find tests -name '__init__.py' -delete || die
}
