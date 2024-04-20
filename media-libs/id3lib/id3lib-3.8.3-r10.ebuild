# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Id3 library for C/C++"
HOMEPAGE="https://id3lib.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P/_}.tar.gz"
S="${WORKDIR}/${P/_}"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"
RESTRICT="test"

RDEPEND="sys-libs/zlib:="
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-text/doxygen )"

DOCS=( AUTHORS ChangeLog HISTORY README THANKS TODO )

PATCHES=(
	"${FILESDIR}"/${P}-zlib.patch
	"${FILESDIR}"/${P}-test_io.patch
	"${FILESDIR}"/${P}-autoconf259.patch
	"${FILESDIR}"/${P}-doxyinput.patch
	"${FILESDIR}"/${P}-unicode16.patch
	"${FILESDIR}"/${P}-gcc-4.3.patch
	"${FILESDIR}"/${P}-missing_nullpointer_check.patch
	"${FILESDIR}"/${P}-security.patch
	"${FILESDIR}"/${P}-vbr-stack-smashing.patch # bug 398571
	"${FILESDIR}"/${P}-configure-clang.patch
)

src_prepare() {
	default

	sed -i 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' {.,zlib}/configure.in || die

	AT_M4DIR="${S}"/m4 eautoreconf
}

src_configure() {
	econf \
		--cache-file="${S}"/config.cache \
		$(use_enable static-libs static)
}

src_compile() {
	default

	if use doc; then
		pushd doc >/dev/null || die
		doxygen Doxyfile || die
		popd >/dev/null || die
	fi
}

src_install() {
	use doc && local HTML_DOCS=( doc/. )
	default
	find "${D}" -name '*.la' -delete || die
}
