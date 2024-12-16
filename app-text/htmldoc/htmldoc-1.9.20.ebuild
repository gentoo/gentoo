# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs xdg

DESCRIPTION="Convert HTML pages into a PDF document"
HOMEPAGE="https://www.msweet.org/htmldoc/"
SRC_URI="https://github.com/michaelrsweet/${PN}/releases/download/v${PV}/${P}-source.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="fltk ssl"

BDEPEND="virtual/pkgconfig"
DEPEND="
	media-libs/libjpeg-turbo:=
	>=media-libs/libpng-1.4:0=
	net-libs/gnutls:=
	net-print/cups
	sys-libs/zlib
	fltk? ( x11-libs/fltk:1 )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/htmldoc-1.9.20_do-not-fortify-source.patch )

src_prepare() {
	default
	eautoreconf

	# Fix the documentation path in a few places. Some Makefiles aren't
	# autotoolized =(
	for file in configure doc/Makefile doc/htmldoc.man; do
		sed -i "${file}" \
			-e "s:/doc/htmldoc:/doc/${PF}/html:g" \
		|| die "failed to fix documentation path in ${file}"
	done
}

src_configure() {
	filter-lto # -Werror=odr issues
	local myeconfargs=(
		$(use_with fltk gui)
	)

	CC="$(tc-getCC)" CXX="$(tc-getCXX)" econf "${myeconfargs[@]}"
}

src_install() {
	emake STRIPPROG="true" DSTROOT="${ED}" install
}
