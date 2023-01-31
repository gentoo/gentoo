# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

MY_P=python-blosc-${PV}
DESCRIPTION="High performance compressor optimized for binary data"
HOMEPAGE="
	https://www.blosc.org/
	https://github.com/Blosc/python-blosc/
	https://pypi.org/project/blosc/
"
SRC_URI="
	https://github.com/Blosc/python-blosc/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/c-blosc-1.19.0:=
"
DEPEND="
	${RDEPEND}
"
# py-cpuinfo dep is irrelevant for us, as it is only used to configure
# bundled c-blosc build
BDEPEND="
	dev-python/scikit-build[${PYTHON_USEDEP}]
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"

DOCS=( ANNOUNCE.rst README.rst RELEASE_NOTES.rst )

src_configure() {
	export USE_SYSTEM_BLOSC=1
	export BLOSC_DIR="${EPREFIX}/usr"
}

python_test() {
	"${EPYTHON}" -m blosc.test -v || die
}
