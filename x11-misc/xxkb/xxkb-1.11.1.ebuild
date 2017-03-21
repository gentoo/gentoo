# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils multilib

DESCRIPTION="eXtended XKB - assign different keymaps to different windows"
HOMEPAGE="https://sourceforge.net/projects/xxkb/"
SRC_URI="
	mirror://sourceforge/${PN}/${P}-src.tar.gz
	svg? ( https://dev.gentoo.org/~jer/${PN}-flags.tar.bz2 )
"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="svg"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXt
	svg? (
		dev-libs/glib:2
		gnome-base/librsvg:2
		x11-libs/gtk+:2
	)
"
DEPEND="
	${RDEPEND}
	app-text/rman
	svg? ( virtual/pkgconfig )
	x11-misc/imake
"

src_prepare() {
	if use svg; then
		mv "${WORKDIR}"/flags . || die
		epatch "${FILESDIR}"/svg-flags.patch
		epatch "${FILESDIR}"/svg-appdefaults.patch
	fi

	epatch "${FILESDIR}"/missing_init.patch
}

src_configure() {
	xmkmf $(usex svg -DWITH_SVG_SUPPORT '') || die
}

src_compile() {
	emake \
		CDEBUGFLAGS="${CFLAGS}" \
		EXTRA_LIBRARIES="-lXext" \
		LOCAL_LDFLAGS="${LDFLAGS}" \
		PIXMAPDIR=/usr/share/xxkb \
		PROJECTROOT=/usr
}

src_install() {
	local myopts
	if use svg; then
		myopts="PIXMAPS=flags/de.svg flags/pl.svg flags/il.svg flags/by.svg \
		flags/ua.svg flags/su.svg flags/ru.svg flags/bg.svg flags/en.svg"
	else
		myopts="FOOBAR=buzz"
	fi

	emake "${myopts}"  DESTDIR="${D}" install
	rm -r "${D}"/usr/$(get_libdir)/X11/app-defaults || die

	emake DESTDIR="${D}" install.man

	insinto /usr/share/xxkb
	use svg || doins "${FILESDIR}"/*.xpm
	dodoc README* CHANGES*
}
