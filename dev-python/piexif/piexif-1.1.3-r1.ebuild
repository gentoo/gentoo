# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{8..10} )

inherit edos2unix distutils-r1

DESCRIPTION="Exif manipulation with pure Python"
HOMEPAGE="https://github.com/hMatoba/Piexif
	https://pypi.org/project/piexif/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	app-arch/unzip
	test? ( dev-python/pillow[jpeg,${PYTHON_USEDEP}] )"
RDEPEND=""

PATCHES=(
	# From https://github.com/hMatoba/Piexif/pull/109
	"${FILESDIR}"/${P}-tests-pillow-7.2.0.patch
)

src_prepare() {
	edos2unix tests/s_test.py  # to be able to patch it
	default
}

python_test() {
	"${PYTHON}" setup.py test || die
}
