# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
inherit desktop distutils-r1 optfeature xdg

DESCRIPTION="GTK image viewer for comic book archives"
HOMEPAGE="https://mcomix.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 arm64 ~riscv ~x86"

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
	gunzip share/man/man1/mcomix.1.gz || die
}

src_install() {
	distutils-r1_src_install

	# Application meta files are not installed automatically anymore
	domenu share/applications/*.desktop
	local x
	for x in 16 22 24 32 48 256 scalable; do
		doicon -s ${x} share/icons/hicolor/${x}*/*
	done
	doman share/man/man1/mcomix.1
	insinto /usr/share/metainfo
	doins share/metainfo/*.xml
	insinto /usr/share/mime/packages
	doins share/mime/packages/*.xml
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "RAR (.cbr) archives" app-arch/unrar
	optfeature "7Zip archives" app-arch/p7zip
	optfeature "LHA/LZA archives" app-arch/lha
	optfeature "PDF files" app-text/mupdf
}
