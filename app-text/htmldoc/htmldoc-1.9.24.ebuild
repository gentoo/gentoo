# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/michaelrsweet.asc
inherit autotools flag-o-matic toolchain-funcs verify-sig xdg

DESCRIPTION="Convert HTML pages into a PDF document"
HOMEPAGE="https://www.msweet.org/htmldoc/"
SRC_URI="
	https://github.com/michaelrsweet/${PN}/releases/download/v${PV}/${P}-source.tar.gz
	verify-sig? ( https://github.com/michaelrsweet/${PN}/releases/download/v${PV}/${P}-source.tar.gz.sig )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="fltk http"

BDEPEND="
	virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-michaelrsweet )
"
DEPEND="
	http? ( >=net-print/cups-2.2 )
	media-libs/libjpeg-turbo:=
	>=media-libs/libpng-1.6:0=
	virtual/zlib:=
	fltk? ( >=x11-libs/fltk-1.3:1= )
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf

	# Build verbosely
	sed -i -e '/.SILENT:/d' Makedefs.in || die

	# Respect CFLAGS
	sed -i -e 's:-Os -g::' configure.ac configure || die

	# We already default to _F_S in Gentoo
	sed -i -e 's: -D_FORTIFY_SOURCE=3::' configure.ac configure || die

	# Fix the documentation path in a few places. Some Makefiles aren't
	# autotoolized =(
	for file in configure doc/Makefile doc/htmldoc.man; do
		sed -i "${file}" \
			-e "s:/doc/htmldoc:/doc/${PF}/html:g" \
		|| die "failed to fix documentation path in ${file}"
	done
}

src_configure() {
	# ODR (link_t)
	filter-lto

	local myeconfargs=(
		$(use_with http)
		$(use_with fltk gui)
	)

	CC="$(tc-getCC)" CXX="$(tc-getCXX)" econf "${myeconfargs[@]}"
}

src_install() {
	emake STRIPPROG="true" DSTROOT="${ED}" install
}
