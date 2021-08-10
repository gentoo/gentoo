# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs xdg

DESCRIPTION="Convert HTML pages into a PDF document"
HOMEPAGE="https://www.msweet.org/htmldoc/"
SRC_URI="https://github.com/michaelrsweet/${PN}/releases/download/v${PV}/${P}-source.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ppc ppc64 sparc x86"
IUSE="fltk ssl"

BDEPEND="virtual/pkgconfig"
DEPEND="
	>=media-libs/libpng-1.4:0=
	sys-libs/zlib
	virtual/jpeg:0
	ssl? ( net-libs/gnutls )
	fltk? ( x11-libs/fltk:1 )
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf

	# Make sure not to use the libs htmldoc ships with
	rm -r jpeg png zlib || die "failed to unbundle jpeg, png, and zlib"

	# Fix the documentation path in a few places. Some Makefiles aren't
	# autotoolized =(
	for file in configure doc/Makefile doc/htmldoc.man; do
		sed -i "${file}" \
			-e "s:/doc/htmldoc:/doc/${PF}/html:g" \
		|| die "failed to fix documentation path in ${file}"
	done
}

src_configure() {
	local myeconfargs=(
		$(use_with fltk gui)
		$(use_enable ssl)
		$(use_enable ssl gnutls)
		--disable-localjpeg
		--disable-localpng
		--disable-localzlib
	)

	CC="$(tc-getCC)" CXX="$(tc-getCXX)" econf "${myeconfargs[@]}"
}

src_install() {
	emake STRIPPROG="true" DSTROOT="${ED}" install
}
