# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Simple interactive calendar program with a notebook capability"
HOMEPAGE="https://www.freebsd.org/"
SRC_URI="ftp://daemon.jp.FreeBSD.org/pub/FreeBSD-jp/ports-jp/LOCAL_PORTS/${P}+i18n.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 x86"
IUSE="motif"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXt
	motif? (
		x11-libs/libXmu
		x11-libs/motif
	)
	!motif? ( x11-libs/libXaw )"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-clang16.patch
)

src_prepare() {
	default

	sed -e "s|%%XCALENDAR_LIBDIR%%|${EPREFIX}/usr/$(get_libdir)/xcalendar|" \
		-e "s|/usr/local/X11R5/lib/X11/|${EPREFIX}/usr/$(get_libdir)/|" \
		< XCalendar.sed > XCalendar || die
}

src_compile() {
	tc-export CC
	append-cflags -std=gnu89 # old codebase, incompatible with c2x

	if use motif; then
		append-cppflags $($(tc-getPKG_CONFIG) --cflags x11 xmu xt || die)
		append-libs -lXm $($(tc-getPKG_CONFIG) --libs x11 xmu xt || die)
	else
		append-cppflags -DATHENA $($(tc-getPKG_CONFIG) --cflags x11 xaw7 xt || die)
		append-libs $($(tc-getPKG_CONFIG) --libs x11 xaw7 xt || die)
	fi

	emake LDLIBS="${LIBS}" -f /dev/null -E "xcalendar: dayeditor.o lists.o"
}

src_install() {
	dobin xcalendar
	newman xcalendar.man xcalendar.1

	insinto /usr/share/X11/app-defaults
	doins XCalendar

	insinto /usr/$(get_libdir)/xcalendar
	doins *.xbm *.hlp

	einstalldocs
}
