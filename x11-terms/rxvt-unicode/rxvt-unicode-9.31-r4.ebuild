# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GENTOO_DEPEND_ON_PERL=no
inherit autotools desktop systemd perl-module prefix

COLOUR_PATCH_NAME="${PN}-9.31_24-bit-color_aur-9.31-20239117.patch"

DESCRIPTION="rxvt clone with xft and unicode support"
HOMEPAGE="http://software.schmorp.de/pkg/rxvt-unicode.html"
SRC_URI="
	http://dist.schmorp.de/rxvt-unicode/Attic/${P}.tar.bz2
	https://dev.gentoo.org/~marecki/dists/${CATEGORY}/${PN}/${COLOUR_PATCH_NAME}.xz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ppc ppc64 ~riscv ~sparc ~x86"
IUSE="24-bit-color 256-color blink fading-colors +font-styles gdk-pixbuf iso14755 +mousewheel
	perl startup-notification unicode3 wide-glyphs xft ${GENTOO_PERL_USESTRING}"

RDEPEND="
	dev-libs/libptytty
	media-libs/fontconfig
	>=sys-libs/ncurses-5.7-r6:=
	x11-libs/libX11
	x11-libs/libXrender
	x11-libs/libXt
	gdk-pixbuf? ( x11-libs/gdk-pixbuf )
	perl? (
		${GENTOO_PERL_DEPSTRING}
		dev-lang/perl:=
	)
	startup-notification? ( x11-libs/startup-notification )
	xft? ( x11-libs/libXft )
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-9.06-case-insensitive-fs.patch
	"${FILESDIR}"/${PN}-9.21-xsubpp.patch
	"${FILESDIR}"/${PN}-9.31-enable-wide-glyphs.patch
	"${FILESDIR}"/${PN}-9.31-perl5.38.patch
	"${FILESDIR}"/${PN}-9.31-osc-colour-command-termination.patch
	"${FILESDIR}"/${PN}-9.31-cxx20.patch
)
DOCS=(
	Changes
	README.FAQ
	doc/README.xvt
	doc/changes.txt
	doc/etc/${PN}.term{cap,info}
	doc/rxvt-tabbed
)

src_prepare() {
	default

	# Current patch is too aggressive to apply unconditionally, see Bug #801571
	if use 24-bit-color; then
		eapply "${WORKDIR}"/${COLOUR_PATCH_NAME}
		eautoreconf
	fi

	# kill the rxvt-unicode terminfo file - #192083
	sed -i -e "/rxvt-unicode.terminfo/d" doc/Makefile.in || die "sed failed"

	# use xsubpp from Prefix - #506500
	hprefixify -q '"' -w "/xsubpp/" src/Makefile.in
}

src_configure() {
	# --enable-everything goes first: the order of the arguments matters
	local myconf=(
		--enable-everything
		$(use_enable 256-color)
		$(use_enable blink text-blink)
		$(use_enable fading-colors fading)
		$(use_enable font-styles)
		$(use_enable gdk-pixbuf pixbuf)
		$(use_enable iso14755)
		$(use_enable mousewheel)
		$(use_enable perl)
		$(use_enable startup-notification)
		$(use_enable unicode3)
		$(use_enable wide-glyphs)
		$(use_enable xft)
	)
	if use 24-bit-color; then
		myconf+=( --enable-24-bit-color )
	fi
	econf "${myconf[@]}"
}

src_compile() {
	default

	sed -i \
		-e 's/RXVT_BASENAME = "rxvt"/RXVT_BASENAME = "urxvt"/' \
		"${S}"/doc/rxvt-tabbed || die
}

src_test() {
	# Avoid perl-module_src_test (bug #963096)
	default
}

src_install() {
	default

	systemd_douserunit "${FILESDIR}"/urxvtd.service
	systemd_douserunit "${FILESDIR}"/urxvtd.socket

	make_desktop_entry urxvt rxvt-unicode utilities-terminal \
		"System;TerminalEmulator"
}

pkg_postinst() {
	if use 24-bit-color; then
		ewarn
		ewarn "You have enabled 24-bit colour support in ${PN}, which is UNOFFICIAL and INCOMPLETE."
		ewarn "You may or may not encounter visual glitches or stability issues. When in doubt,"
		ewarn "rebuild =${CATEGORY}/${PF} with USE=-24-bit-color (the default setting)."
		ewarn
	fi
	if use perl && ! use fading-colors; then
		ewarn "Note that some of the Perl plug-ins bundled with ${PN} will fail to load without USE=fading-colors"
	fi
	if use wide-glyphs; then
		ewarn
		ewarn "You have enabled wide-glyph support in ${PN}, which is UNOFFICIAL."
		ewarn "You may or may not encounter visual glitches or stability issues. When in doubt,"
		ewarn "rebuild =${CATEGORY}/${PF} with USE=-wide-glyphs (the default setting)."
		ewarn
	fi
}
