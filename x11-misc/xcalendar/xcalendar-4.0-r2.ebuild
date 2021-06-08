# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="A simple interactive calendar program with a notebook capability"
HOMEPAGE="https://www.freebsd.org/"
SRC_URI="ftp://daemon.jp.FreeBSD.org/pub/FreeBSD-jp/ports-jp/LOCAL_PORTS/${P}+i18n.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 x86"
IUSE="motif"

RDEPEND="x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXaw
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	>=x11-misc/imake-1.0.8-r1
	x11-misc/gccmakedep
	motif? ( >=x11-libs/motif-2.3:0 )"

S=${WORKDIR}/${PN}
PATCHES=( "${FILESDIR}"/${P}-implicits.patch )

src_prepare() {
	use motif && PATCHES+=( "${FILESDIR}"/${P}-motif-gentoo.diff )
	default
	sed -e "s:%%XCALENDAR_LIBDIR%%:/usr/$(get_libdir)/xcalendar:" \
		-e "s:/usr/local/X11R5/lib/X11/:/usr/$(get_libdir)/:" \
		-i XCalendar.sed || die
}

src_configure() {
	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" \
		IMAKECPP="${IMAKECPP:-$(tc-getCPP)}" xmkmf -a || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CDEBUGFLAGS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}"
}

src_install() {
	dobin xcalendar
	newman xcalendar.man xcalendar.1

	insinto /usr/share/X11/app-defaults
	newins XCalendar.sed XCalendar

	insinto /usr/$(get_libdir)/xcalendar
	doins *.xbm *.hlp

	einstalldocs
}
