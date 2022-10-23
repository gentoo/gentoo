# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1 optfeature xdg

DESCRIPTION="GTK image viewer for comic book archives"
HOMEPAGE="http://mcomix.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	>=dev-python/pillow-6.0.0[${PYTHON_USEDEP}]
	>=dev-python/pycairo-1.16.0[${PYTHON_USEDEP}]
	>=dev-python/pygobject-3.36.0[${PYTHON_USEDEP}]
	media-libs/libjpeg-turbo:0
	x11-libs/gtk+:3[introspection]"
BDEPEND="sys-devel/gettext"
# Most tests are quite old and do not run
RESTRICT="test"

src_prepare() {
	default

	# Uncompress man page
	gunzip mcomix.1.gz || die
	sed -e "s/mcomix.1.gz/mcomix.1/" -i setup.py || die
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "RAR (.cbr) archives" app-arch/unrar
	optfeature "7Zip archives" app-arch/p7zip
	optfeature "LHA/LZA archives" app-arch/lha
	optfeature "PDF files" app-text/mupdf
}
