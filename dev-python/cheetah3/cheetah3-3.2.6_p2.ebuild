# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

MY_P=${P/_p/.post}
DESCRIPTION="Python-powered template engine and code generator"
HOMEPAGE="https://cheetahtemplate.org/ https://pypi.org/project/Cheetah3/"
SRC_URI="
	https://github.com/CheetahTemplate3/${PN}/archive/${PV/_p/.post}.tar.gz
		-> ${MY_P}.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
KEYWORDS="amd64 arm arm64 ~loong ~ppc64 ~riscv x86"
SLOT="0"

RDEPEND="
	dev-python/markdown[${PYTHON_USEDEP}]
	!dev-python/cheetah
"
BDEPEND="${RDEPEND}"

DOCS=( ANNOUNCE.rst README.rst TODO )

python_prepare_all() {
	# Disable broken tests.
	sed -i -e "/Unicode/d" -i Cheetah/Tests/Test.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	"${EPYTHON}" Cheetah/Tests/Test.py || die "Tests fail with ${EPYTHON}"
}
