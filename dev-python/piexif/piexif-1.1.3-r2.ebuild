# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit edos2unix distutils-r1 pypi

DESCRIPTION="Exif manipulation with pure Python"
HOMEPAGE="
	https://github.com/hMatoba/Piexif/
	https://pypi.org/project/piexif/
"
SRC_URI="$(pypi_sdist_url "${PN}" "${PV}" .zip)"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	app-arch/unzip
	test? ( dev-python/pillow[jpeg,${PYTHON_USEDEP}] )
"

PATCHES=(
	# From https://github.com/hMatoba/Piexif/pull/109
	"${FILESDIR}"/${P}-tests-pillow-7.2.0.patch
)

src_prepare() {
	edos2unix tests/s_test.py  # to be able to patch it
	default
}

python_test() {
	esetup.py test
}
