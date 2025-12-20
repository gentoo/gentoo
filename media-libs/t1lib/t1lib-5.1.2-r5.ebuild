# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic libtool toolchain-funcs

DESCRIPTION="Type 1 Font Rasterizer Library for UNIX/X11"
HOMEPAGE="https://www.t1lib.org/"
SRC_URI="https://www.ibiblio.org/pub/Linux/libs/graphics/${P}.tar.gz"

LICENSE="LGPL-2 GPL-2"
SLOT="5"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="X doc static-libs"

RDEPEND="
	X? (
		x11-libs/libXaw
		x11-libs/libX11
		x11-libs/libXt
	)
"
DEPEND="
	${RDEPEND}
	doc? ( virtual/latex-base )
	X? ( x11-base/xorg-proto )
"

PATCHES=(
	"${FILESDIR}"/${PN}-5.1.1-parallel.patch
	"${FILESDIR}"/${PN}-do-not-install-t1lib_doc-r1.patch
	"${FILESDIR}"/${PN}-5.1.2-format-security.patch
	"${FILESDIR}"/${PN}-5.1.2-CVE-2010-2642_2011-0433_2011-5244.patch
	"${FILESDIR}"/${PN}-5.1.2-CVE-2011-0764.patch
	"${FILESDIR}"/${PN}-5.1.2-CVE-2011-1552_1553_1554.patch
	"${FILESDIR}"/${PN}-5.1.2-c99.patch
	"${FILESDIR}"/${PN}-5.1.2-c99-configure.patch
)

src_prepare() {
	default

	sed -i -e "s:dvips:#dvips:" "${S}"/doc/Makefile.in || die
	sed -i -e "s:\./\(t1lib\.config\):/etc/t1lib/\1:" "${S}"/xglyph/xglyph.c || die

	eautoconf
	# Needed for sane .so versioning on fbsd. Please don't drop.
	elibtoolize
}

src_configure() {
	# bug #943882
	append-cflags -std=gnu17
	# lto-type-mismatch
	filter-lto

	econf \
		--datadir="${EPREFIX}/etc" \
		$(use_enable static-libs static) \
		$(use_with X x)
}

src_compile() {
	local myopt=""
	tc-export CC

	use alpha && append-flags -mieee

	if ! use doc; then
		myopt="without_doc"
	else
		VARTEXFONTS="${T}/fonts"
	fi

	emake ${myopt}
}

src_install() {
	default

	if ! use static-libs; then
		find "${ED}" -type f \( -name '*.la' -o -name '*.a' \) -delete || die
	fi

	dodoc Changes README*
	if use doc; then
		docinto pdf
		dodoc doc/*.pdf
		docompress -x /usr/share/doc/${PF}/pdf
	fi
}
