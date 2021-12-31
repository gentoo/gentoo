# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_6} ) # Tests crash with pypy

inherit distutils-r1 flag-o-matic prefix

DESCRIPTION="Tools for generating printable PDF documents from any data source"
HOMEPAGE="http://www.reportlab.com/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz
	http://www.reportlab.com/ftp/fonts/pfbfer-20070710.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

RDEPEND="
	<dev-python/pillow-6[tiff,truetype,jpeg(+),${PYTHON_USEDEP}]
	media-libs/libart_lgpl
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	>=dev-python/setuptools-2.2[${PYTHON_USEDEP}]
	app-arch/unzip
"

PATCHES=(
	"${FILESDIR}"/reportlab-no-pip.patch
)

src_unpack() {
	unpack ${P}.tar.gz
	cd ${P}/src/reportlab/fonts || die
	unpack pfbfer-20070710.zip
}

python_prepare_all() {
	sed -i \
		-e 's|/usr/local/Acrobat|/opt/Acrobat|g' \
		-e 's|%(HOME)s/fonts|%(HOME)s/.fonts|g' \
		src/reportlab/rl_config.py || die

	eprefixify setup.py
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_compile() {
	if ! python_is_python3; then
		local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	fi
	distutils-r1_python_compile
}

python_test() {
	pushd tests > /dev/null || die
	"${PYTHON}" runAll.py || die "Testing failed with ${EPYTHON}"
	popd > /dev/null || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )
	use examples && local EXAMPLES=( demos/. tools/pythonpoint/demos )

	distutils-r1_python_install_all
}
