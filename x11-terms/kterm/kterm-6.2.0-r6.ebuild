# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit flag-o-matic toolchain-funcs

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
	sys-libs/ncurses:=
	x11-libs/libXaw
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libxkbfile
	Xaw3d? ( x11-libs/libXaw3d )"
DEPEND="${RDEPEND}
	x11-misc/gccmakedep
	x11-misc/imake"

PATCHES=(
	"${WORKDIR}"/${P}-wpi.patch		# wallpaper patch
	"${WORKDIR}"/${P}.ext02.patch		# JIS 0213 support
	"${FILESDIR}"/${PN}-openpty.patch
	"${FILESDIR}"/${PN}-gentoo.patch
	"${FILESDIR}"/${PN}-ad-gentoo.patch
	"${FILESDIR}"/${PN}-underline.patch
)

src_prepare(){
	default
	use Xaw3d && eapply "${FILESDIR}"/${PN}-Xaw3d.patch
}

src_configure() {
	xmkmf -a || die
}

src_compile(){
	emake \
		CC="$(tc-getCC)" \
		CDEBUGFLAGS="${CFLAGS}" \
		LOCAL_LDFLAGS="${LDFLAGS}" \
		TERMCAPLIB="$("$(tc-getPKG_CONFIG)" --libs ncurses)" \
		XAPPLOADDIR="${EPREFIX}/usr/share/X11/app-defaults"
}

src_install(){
	emake \
		BINDIR="${EPREFIX}/usr/bin" \
		XAPPLOADDIR="${EPREFIX}/usr/share/X11/app-defaults" \
		DESTDIR="${D}" \
		install
	einstalldocs

	# install man pages
	newman ${PN}.man ${PN}.1
	iconv -f ISO-2022-JP -t UTF-8 ${PN}.jman > ${PN}.ja.1
	doman ${PN}.ja.1

	# Remove link to avoid collision
	rm -f "${ED}"/usr/lib/X11/app-defaults
}

pkg_postinst() {
	elog
	elog "KTerm wallpaper support is enabled."
	elog "In order to use this feature,"
	elog "you need specify favourite xpm file with -wp option"
	elog
	elog "\t% ${PN} -wp filename.xpm"
	elog
	elog "or set it with X resource"
	elog
	elog "\tKTerm*wallPaper: /path/to/filename.xpm"
	elog
}
