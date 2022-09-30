# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Japanese Kanji X Terminal"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz
	mirror://gentoo/${P}-wpi.patch.gz
	mirror://gentoo/${P}.ext02.patch.gz"

LICENSE="MIT HPND XC"
SLOT="0"
KEYWORDS="-alpha amd64 ~ppc ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="Xaw3d"

RDEPEND="
	app-text/rman
	sys-libs/ncurses:=
	x11-libs/libXaw
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libxkbfile
	Xaw3d? ( x11-libs/libXaw3d )
	!<games-board/xgammon-0.98-r3
	!<games-board/xscrabble-2.10-r4"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gcc
	virtual/pkgconfig
	x11-misc/gccmakedep
	>=x11-misc/imake-1.0.8-r1"

PATCHES=(
	"${WORKDIR}"/${P}-wpi.patch		# wallpaper patch
	"${WORKDIR}"/${P}.ext02.patch		# JIS 0213 support
	"${FILESDIR}"/${PN}-openpty.patch
	"${FILESDIR}"/${PN}-gentoo.patch
	"${FILESDIR}"/${PN}-ad-gentoo.patch
	"${FILESDIR}"/${PN}-underline.patch
)

src_prepare() {
	default
	use Xaw3d && eapply "${FILESDIR}"/${PN}-Xaw3d.patch
}

src_configure() {
	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" \
		IMAKECPP="${IMAKECPP:-${CHOST}-gcc -E}" xmkmf -a || die
}

src_compile() {
	local myemakeargs=(
		CC="$(tc-getCC)"
		CDEBUGFLAGS="${CFLAGS}"
		LOCAL_LDFLAGS="${LDFLAGS}"
		TERMCAPLIB="$("$(tc-getPKG_CONFIG)" --libs ncurses)"
		XAPPLOADDIR="${EPREFIX}/usr/share/X11/app-defaults"
	)
	emake "${myemakeargs[@]}"
}

src_install() {
	local myemakeargs=(
		DESTDIR="${D}"
		BINDIR="${EPREFIX}/usr/bin"
		XAPPLOADDIR="${EPREFIX}/usr/share/X11/app-defaults"
	)
	emake "${myemakeargs[@]}" install
	einstalldocs

	newman ${PN}.man ${PN}.1
	iconv -f ISO-2022-JP -t UTF-8 ${PN}.jman > ${PN}.ja.1 || die
	doman ${PN}.ja.1

	# remove link to avoid collision (bug #668892,706322)
	rm "${ED}"/usr/$(get_libdir)/X11/app-defaults || die
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
