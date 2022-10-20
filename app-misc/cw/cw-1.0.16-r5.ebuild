# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WANT_AUTOMAKE="none"
inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="A non-intrusive real-time ANSI color wrapper for common unix-based commands"
HOMEPAGE="http://cwrapper.sourceforge.net"
SRC_URI="mirror://sourceforge/cwrapper/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=(
	"${FILESDIR}"/${PV}-ldflags.patch
	"${FILESDIR}"/${PV}-path.patch
	"${FILESDIR}"/${PV}-collision.patch
	"${FILESDIR}"/${PV}-format-security.patch
	"${FILESDIR}"/${P}-replace-isastream-with-fcntl.patch
	"${FILESDIR}"/${P}-fix-configure-for-newer-autotools.patch
	"${FILESDIR}"/${P}-Respect-CPPFLAGS.patch
)

src_prepare() {
	default

	gunzip "${S}"/man/*.gz || die

	eautoreconf
}

src_configure() {
	tc-export CC

	append-cppflags -D_GNU_SOURCE

	econf
}

src_compile() {
	emake local
}

src_install() {
	insinto /usr/share/cw
	doins etc/*

	exeinto /usr/libexec/cw
	doexe def/*

	doman man/cwu.1
	doman man/cwe.1
	newman man/cw.1 color-wrapper
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
