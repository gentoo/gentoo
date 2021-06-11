# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools cvs desktop vcs-clean prefix

DESCRIPTION="rxvt clone with xft and unicode support"
HOMEPAGE="http://software.schmorp.de/pkg/rxvt-unicode.html"
ECVS_SERVER="cvs.schmorp.de/schmorpforge"
ECVS_USER="anonymous"
ECVS_MODULE="rxvt-unicode"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="
	256-color blink fading-colors +font-styles gdk-pixbuf iso14755 +mousewheel
	+perl startup-notification unicode3 +utmp +wtmp xft
"
RESTRICT="test"

RDEPEND="
	>=sys-libs/ncurses-5.7-r6:=
	media-libs/fontconfig
	x11-libs/libX11
	x11-libs/libXrender
	gdk-pixbuf? ( x11-libs/gdk-pixbuf )
	kernel_Darwin? ( dev-perl/Mac-Pasteboard )
	perl? ( dev-lang/perl:= )
	startup-notification? ( x11-libs/startup-notification )
	xft? ( x11-libs/libXft )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto
"
DOCS=(
	Changes
	README.FAQ
	doc/README.xvt
	doc/changes.txt
	doc/etc/${PN}.term{cap,info}
	doc/rxvt-tabbed
)
S=${WORKDIR}/${PN}

src_prepare() {
	ecvs_clean
	eapply \
		"${FILESDIR}"/${PN}-9.06-case-insensitive-fs.patch \
		"${FILESDIR}"/${PN}-9.21-xsubpp.patch

	eapply_user

	# kill the rxvt-unicode terminfo file - #192083
	sed -i -e "/rxvt-unicode.terminfo/d" doc/Makefile.in || die "sed failed"

	# use xsubpp from Prefix - #506500
	hprefixify -q '"' -w "/xsubpp/" src/Makefile.in

	eautoreconf
}

src_configure() {
	# --enable-everything goes first: the order of the arguments matters
	econf --enable-everything \
		$(use_enable 256-color) \
		$(use_enable blink text-blink) \
		$(use_enable fading-colors fading) \
		$(use_enable font-styles) \
		$(use_enable gdk-pixbuf pixbuf) \
		$(use_enable iso14755) \
		$(use_enable mousewheel) \
		$(use_enable perl) \
		$(use_enable startup-notification) \
		$(use_enable unicode3) \
		$(use_enable utmp) \
		$(use_enable wtmp) \
		$(use_enable xft)
}

src_compile() {
	default

	sed -i \
		-e 's/RXVT_BASENAME = "rxvt"/RXVT_BASENAME = "urxvt"/' \
		"${S}"/doc/rxvt-tabbed || die
}

src_install() {
	default

	make_desktop_entry urxvt rxvt-unicode utilities-terminal \
		"System;TerminalEmulator"
}
