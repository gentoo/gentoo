# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Tools for generating printable PDF documents from any data source"
HOMEPAGE="
	https://www.reportlab.com/
	https://pypi.org/project/reportlab/
"
SRC_URI+="
	https://www.reportlab.com/ftp/fonts/pfbfer-20070710.zip
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/pillow[tiff,truetype,jpeg(+),${PYTHON_USEDEP}]
"
BDEPEND="
	app-arch/unzip
"

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
	EOF
}

python_test() {
	pushd tests >/dev/null || die
	"${EPYTHON}" runAll.py --post-install --verbosity=2 ||
		die "Testing failed with ${EPYTHON}"
	popd >/dev/null || die
}
