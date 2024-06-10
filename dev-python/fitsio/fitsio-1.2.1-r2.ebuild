# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Python library to read from and write to FITS files"
HOMEPAGE="
	https://github.com/esheldon/fitsio/
	https://pypi.org/project/fitsio/
"
SRC_URI="
	https://github.com/esheldon/fitsio/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
	https://github.com/esheldon/fitsio/pull/394.patch
		-> fitsio-1.2.1-gcc-14.patch
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	>=dev-python/numpy-1.11:=[${PYTHON_USEDEP}]
	sci-libs/cfitsio:0=
"
RDEPEND="
	${DEPEND}
"

distutils_enable_tests pytest

PATCHES=(
	# https://github.com/esheldon/fitsio/pull/394
	"${DISTDIR}/${P}-gcc-14.patch"
	# https://github.com/esheldon/fitsio/pull/390
	"${FILESDIR}/${P}-numpy-2.patch"
)

export FITSIO_USE_SYSTEM_FITSIO=1

python_test() {
	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	epytest
}
