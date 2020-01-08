# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Id3 library for C/C++"
HOMEPAGE="http://id3lib.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P/_}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-linux ~x86-linux ~x86-macos ~x86-solaris"
IUSE="doc static-libs"

RDEPEND="sys-libs/zlib:="
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

RESTRICT="test"

DOCS=( AUTHORS ChangeLog HISTORY README THANKS TODO )

S=${WORKDIR}/${P/_}

PATCHES=(
	"${FILESDIR}"/${P}-zlib.patch
	"${FILESDIR}"/${P}-test_io.patch
	"${FILESDIR}"/${P}-autoconf259.patch
	"${FILESDIR}"/${P}-doxyinput.patch
	"${FILESDIR}"/${P}-unicode16.patch
	"${FILESDIR}"/${P}-gcc-4.3.patch
	"${FILESDIR}"/${P}-missing_nullpointer_check.patch
	"${FILESDIR}"/${P}-security.patch
)

src_prepare() {
	default

	sed -i 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' {.,zlib}/configure.in || die

	AT_M4DIR=${S}/m4 eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
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
