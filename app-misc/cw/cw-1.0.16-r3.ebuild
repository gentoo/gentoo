# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/cw/cw-1.0.16-r3.ebuild,v 1.1 2015/06/21 14:09:44 jlec Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="A non-intrusive real-time ANSI color wrapper for common unix-based commands"
HOMEPAGE="http://cwrapper.sourceforge.net/"
SRC_URI="mirror://sourceforge/cwrapper/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	epatch \
		"${FILESDIR}"/${PV}-ldflags.patch \
		"${FILESDIR}"/${PV}-path.patch \
		"${FILESDIR}"/${PV}-collision.patch \
		"${FILESDIR}"/${PV}-format-security.patch
	tc-export CC
}

src_compile() {
	emake local
}

src_install() {
	insinto /usr/share/cw
	doins etc/*

	exeinto /usr/libexec/cw
	doexe def/*

	doman man/cwu*
	newman man/cw.* color-wrapper
	dodoc CHANGES CONTRIB INSTALL README PLATFORM doc/README*

	dobin bin/{cwu,colorcfg}
	# app-misc/color currently conflicts; hopefully 'colors' is safe
	newbin bin/color colors
	# media-radio/unixcw currently conflicts;
	newbin bin/cw color-wrapper
}

pkg_postinst() {
	ebegin "Updating definition files"
	cwu /usr/libexec/cw /usr/bin/color-wrapper # >/dev/null
	eend $?

	elog "To enable color-wrapper, as your user, run:"
	elog "  colorcfg [1|2|3]"
	elog "to add relevant environment variables to your ~/.bash_profile"
	elog "Run colorcfg without options to see what [1|2|3] means."
	elog
	elog "After sourcing your ~/.bash_profile, commands for which definitions"
	elog "are provided should have colored output."
	elog
	elog "To enable/disable colored output, run: 'colors [on|off]'."
}
