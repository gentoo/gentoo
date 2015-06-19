# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/rxvt-unicode/rxvt-unicode-9.21.ebuild,v 1.11 2015/02/28 13:28:28 ago Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="rxvt clone with xft and unicode support"
HOMEPAGE="http://software.schmorp.de/pkg/rxvt-unicode.html"
SRC_URI="http://dist.schmorp.de/rxvt-unicode/Attic/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris"
IUSE="
	256-color alt-font-width blink buffer-on-clear +focused-urgency
	fading-colors +font-styles iso14755 +mousewheel +perl pixbuf secondary-wheel
	startup-notification xft unicode3 +vanilla wcwidth
"

RDEPEND="
	>=sys-libs/ncurses-5.7-r6
	kernel_Darwin? ( dev-perl/Mac-Pasteboard )
	media-libs/fontconfig
	perl? ( dev-lang/perl:= )
	pixbuf? ( x11-libs/gdk-pixbuf x11-libs/gtk+:2 )
	startup-notification? ( x11-libs/startup-notification )
	x11-libs/libX11
	x11-libs/libXrender
	xft? ( x11-libs/libXft )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	x11-proto/xproto
"

RESTRICT="test"
REQUIRED_USE="vanilla? ( !alt-font-width !buffer-on-clear focused-urgency !secondary-wheel !wcwidth )"

src_prepare() {
	# fix for prefix not installing properly
	epatch \
		"${FILESDIR}"/${PN}-9.06-case-insensitive-fs.patch \
		"${FILESDIR}"/${PN}-9.21-xsubpp.patch

	if ! use vanilla; then
		ewarn "You are going to include unsupported third-party bug fixes/features."
		ewarn "If you want even more control over patches, then set USE=vanilla"
		ewarn "and store your patch set in /etc/portage/patches/${CATEGORY}/${PF}/"

		use wcwidth && epatch doc/wcwidth.patch

		# bug #240165
		use focused-urgency || epatch "${FILESDIR}"/${PN}-9.06-no-urgency-if-focused.diff

		# bug #263638
		epatch "${FILESDIR}"/${PN}-9.06-popups-hangs.patch

		# bug #237271
		epatch "${FILESDIR}"/${PN}-9.05_no-MOTIF-WM-INFO.patch

		# support for wheel scrolling on secondary screens
		use secondary-wheel && epatch "${FILESDIR}"/${PN}-9.19-secondary-wheel.patch

		# ctrl-l buffer fix
		use buffer-on-clear && epatch "${FILESDIR}"/${PN}-9.14-clear.patch

		use alt-font-width && epatch "${FILESDIR}"/${PN}-9.06-font-width.patch
	fi

	# kill the rxvt-unicode terminfo file - #192083
	sed -i -e "/rxvt-unicode.terminfo/d" doc/Makefile.in || die "sed failed"

	epatch_user

	eautoreconf
}

src_configure() {
	local myconf=''

	use iso14755 || myconf='--disable-iso14755'

	econf --enable-everything \
		$(use_enable 256-color) \
		$(use_enable blink text-blink) \
		$(use_enable fading-colors fading) \
		$(use_enable font-styles) \
		$(use_enable mousewheel) \
		$(use_enable perl) \
		$(use_enable pixbuf) \
		$(use_enable startup-notification) \
		$(use_enable xft) \
		$(use_enable unicode3) \
		${myconf}
}

src_compile() {
	emake || die "emake failed"

	sed -i \
		-e 's/RXVT_BASENAME = "rxvt"/RXVT_BASENAME = "urxvt"/' \
		"${S}"/doc/rxvt-tabbed || die "tabs sed failed"
}

src_install() {
	default

	dodoc \
		README.FAQ Changes doc/README* doc/changes.txt doc/etc/* doc/rxvt-tabbed

	make_desktop_entry urxvt rxvt-unicode utilities-terminal \
		"System;TerminalEmulator"
}

pkg_postinst() {
	if use buffer-on-clear; then
		ewarn "You have enabled the buffer-on-clear USE flag."
		ewarn "Please note that, although this works well for most prompts,"
		ewarn "there have been cases with fancy prompts, like bug #397829,"
		ewarn "where it caused issues. Proceed with caution."
		ewarn "  (keep this terminal open until you make sure it works)"
	fi
	if use secondary-wheel; then
		elog "You have enabled the secondary-wheel USE flag."
		elog "This allows you to scroll in secondary screens"
		elog "(like mutt's message list/view or nano) using the mouse wheel."
		elog
		elog "To actually enable the feature you have to add"
		elog "  URxvt*secondaryWheel: true"
		elog "in your ~/.Xdefaults file"
	fi
}
