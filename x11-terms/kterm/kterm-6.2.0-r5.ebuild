# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Japanese Kanji X Terminal"
#HOMEPAGE="http://www.asahi-net.or.jp/~hc3j-tkg/kterm/"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz
	mirror://gentoo/${P}-wpi.patch.gz
	mirror://gentoo/${P}.ext02.patch.gz"

LICENSE="MIT HPND XC"
SLOT="0"
KEYWORDS="-alpha amd64 ~ppc ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="Xaw3d"

RDEPEND="app-text/rman
	sys-libs/ncurses
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libxkbfile
	x11-libs/libXaw
	x11-libs/libXp
	Xaw3d? ( x11-libs/libXaw3d )"
DEPEND="${RDEPEND}
	x11-misc/gccmakedep
	x11-misc/imake"

src_prepare(){
	epatch "${WORKDIR}"/${P}-wpi.patch		# wallpaper patch
	epatch "${WORKDIR}"/${P}.ext02.patch		# JIS 0213 support
	epatch "${FILESDIR}"/${PN}-openpty.patch
	epatch "${FILESDIR}"/${PN}-gentoo.patch
	epatch "${FILESDIR}"/${PN}-ad-gentoo.patch
	epatch "${FILESDIR}"/${PN}-underline.patch
	use Xaw3d && epatch "${FILESDIR}"/${PN}-Xaw3d.patch
}

src_compile(){
	PKG_CONFIG=$(tc-getPKG_CONFIG)
	xmkmf -a || die
	emake CC="$(tc-getCC)" CDEBUGFLAGS="${CFLAGS}" \
		LOCAL_LDFLAGS="${LDFLAGS} $($PKG_CONFIG --libs ncurses)" \
		XAPPLOADDIR="${EPREFIX}"/usr/share/X11/app-defaults
}

src_install(){
	emake DESTDIR="${D}" BINDIR="${EPREFIX}"/usr/bin XAPPLOADDIR="${EPREFIX}"/usr/share/X11/app-defaults install

	# install man pages
	newman kterm.man kterm.1
	insinto /usr/share/man/ja/man1
	iconv -f ISO-2022-JP -t EUC-JP kterm.jman > kterm.ja.1
	newins kterm.ja.1 kterm.1

	# Remove link to avoid collision
	rm -f "${ED}"/usr/lib/X11/app-defaults

	dodoc README.kt
}

pkg_postinst() {
	elog
	elog "KTerm wallpaper support is enabled."
	elog "In order to use this feature,"
	elog "you need specify favourite xpm file with -wp option"
	elog
	elog "\t% kterm -wp filename.xpm"
	elog
	elog "or set it with X resource"
	elog
	elog "\tKTerm*wallPaper: /path/to/filename.xpm"
	elog
}
