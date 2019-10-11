# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit flag-o-matic libtool toolchain-funcs

DESCRIPTION="A Type 1 Font Rasterizer Library for UNIX/X11"
HOMEPAGE="ftp://metalab.unc.edu/pub/Linux/libs/graphics/"
SRC_URI="ftp://sunsite.unc.edu/pub/Linux/libs/graphics/${P}.tar.gz"

LICENSE="LGPL-2 GPL-2"
SLOT="5"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="X doc static-libs"

RDEPEND="X? (
		x11-libs/libXaw
		x11-libs/libX11
		x11-libs/libXt
	)"
DEPEND="${RDEPEND}
	doc? ( virtual/latex-base )
	X? ( x11-base/xorg-proto )"

PATCHES=(
	"${FILESDIR}"/${PN}-5.1.1-parallel.patch
	"${FILESDIR}"/${PN}-do-not-install-t1lib_doc-r1.patch
	"${FILESDIR}"/${PN}-5.1.2-format-security.patch
	"${FILESDIR}"/${PN}-5.1.2-CVE-2010-2642_2011-0433_2011-5244.patch
	"${FILESDIR}"/${PN}-5.1.2-CVE-2011-0764.patch
	"${FILESDIR}"/${PN}-5.1.2-CVE-2011-1552_1553_1554.patch
)

src_prepare() {
	default

	sed -i -e "s:dvips:#dvips:" "${S}"/doc/Makefile.in
	sed -i -e "s:\./\(t1lib\.config\):/etc/t1lib/\1:" "${S}"/xglyph/xglyph.c
	# Needed for sane .so versionning on fbsd. Please don't drop.
	elibtoolize
}

src_configure() {
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
		VARTEXFONTS=${T}/fonts
	fi

	emake ${myopt}
}

src_install() {
	default

	if ! use static-libs; then
		find "${ED}"usr/lib* -name '*.la' -o -name '*.a' -delete || die
	fi

	dodoc Changes README*
	if use doc; then
		cd doc
		insinto /usr/share/doc/${PF}
		doins *.pdf *.dvi
	fi
}
