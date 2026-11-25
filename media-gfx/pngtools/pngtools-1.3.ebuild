# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="A series of tools for the PNG image format"
HOMEPAGE="https://github.com/mikalstill/pngtools"
SRC_URI="https://github.com/mikalstill/pngtools/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="media-libs/libpng:="
DEPEND="${RDEPEND}"
# https://github.com/mikalstill/pngtools/issues/14
BDEPEND="app-text/docbook-sgml-utils"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3-docbook-dtd.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/875371
	# https://github.com/mikalstill/pngtools/issues/21
	filter-lto

	default
}

src_install() {
	default

	dodoc ABOUT chunks.txt

	docinto examples
	dodoc *.png
}

src_test() {
	# TODO: implement pngtools-1.3/scripts/build-and-test.sh
	# Needs extra python deps for testing, incl venv
	default
}
