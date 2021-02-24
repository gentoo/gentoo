# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Tools for generating printable PDF documents from any data source"
HOMEPAGE="
	https://www.reportlab.com/
	https://pypi.org/project/reportlab/"
SRC_URI="
	mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz
	https://www.reportlab.com/ftp/fonts/pfbfer-20070710.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ppc ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	media-libs/freetype
	media-libs/libart_lgpl
	sys-libs/zlib:="
RDEPEND="
	${DEPEND}
	dev-python/pillow[tiff,truetype,jpeg(+),${PYTHON_USEDEP}]"
BDEPEND="
	app-arch/unzip
	test? ( ${RDEPEND} )"

distutils_enable_sphinx docs/source

PATCHES=(
	# bug 738312, remove -L/usr/lib from link line
	"${FILESDIR}"/${PN}-3.5.48-usr-lib-LLD.patch
)

src_unpack() {
	unpack ${P}.tar.gz
	cd ${P}/src/reportlab/fonts || die
	unpack pfbfer-20070710.zip
}

python_prepare_all() {
	# tests requiring Internet access
	sed -i -e 's:test0:_&:' \
		tests/test_platypus_general.py \
		tests/test_platypus_images.py || die
	sed -i -e 's:test9:_&:' tests/test_lib_utils.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	pushd tests >/dev/null || die
	"${EPYTHON}" runAll.py || die "Testing failed with ${EPYTHON}"
	popd >/dev/null || die
}
