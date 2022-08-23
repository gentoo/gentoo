# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Tools for generating printable PDF documents from any data source"
HOMEPAGE="
	https://www.reportlab.com/
	https://pypi.org/project/reportlab/
"
SRC_URI="
	mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz
	https://www.reportlab.com/ftp/fonts/pfbfer-20070710.zip
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	media-libs/freetype
	media-libs/libart_lgpl
	sys-libs/zlib:=
"
RDEPEND="
	${DEPEND}
	dev-python/pillow[tiff,truetype,jpeg(+),${PYTHON_USEDEP}]
"
BDEPEND="
	app-arch/unzip
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.6.9-paths.patch
	"${FILESDIR}"/${PN}-3.6.11-correct-srclen-type-in-gstate__aapixbuf.patch
)

distutils_enable_sphinx docs/source

src_unpack() {
	unpack ${P}.tar.gz
	cd ${P}/src/reportlab/fonts || die
	unpack pfbfer-20070710.zip
}

src_configure() {
	cat > local-setup.cfg <<-EOF || die
		[OPTIONS]
		no-download-t1-files = 1
		use-system-libart = 1
	EOF
}

python_test() {
	pushd tests >/dev/null || die
	"${EPYTHON}" runAll.py -v || die "Testing failed with ${EPYTHON}"
	popd >/dev/null || die
}
