# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools desktop gnome2-utils

MY_P="${P/_/}"
MY_P="${MY_P/beta/beta-}"
DESCRIPTION="A Panzer General clone written in SDL"
HOMEPAGE="http://lgames.sourceforge.net/LGeneral/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz
	mirror://sourceforge/${PN}/pg-data.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	media-libs/libsdl[sound,video]
	media-libs/sdl-mixer
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	sed -i \
		-e '/desktop_DATA/d' \
		-e '/icon_DATA/d' \
		Makefile.am || die

	cp /usr/share/gettext/config.rpath .
	rm -f missing
	mv configure.in configure.ac
	eautoreconf

	# Build a temporary lgc-pg that knows about ${WORKDIR}:
	cp -pPR "${S}" "${WORKDIR}"/tmp-build || die
	sed -i \
		-e "s:@GENTOO_DATADIR@:/usr/share:" \
		-e "s:@D@::" \
		{lgc-pg,src}/misc.c || die

	cd "${WORKDIR}"/tmp-build || die
	sed -i \
		-e "s:@GENTOO_DATADIR@:/usr/share:" \
		-e "s:@D@:${D}:" \
		{lgc-pg,src}/misc.c || die
}

src_configure() {
	econf $(use_enable nls)

	# Build the temporary lgc-pg:
	cd "${WORKDIR}"/tmp-build || die
	econf \
		--disable-nls \
		--datadir="${D}/usr/share"
}

src_compile() {
	emake

	# Build the temporary lgc-pg:
	cd "${WORKDIR}"/tmp-build || die
	emake
}

src_install() {
	default
	keepdir /usr/share/${PN}/{ai_modules,music,terrain}

	# Generate scenario data:
	dodir /usr/share/${PN}/gfx/{flags,units,terrain} #413901
	SDL_VIDEODRIVER=dummy "${WORKDIR}"/tmp-build/lgc-pg/lgc-pg --separate-bridges \
		-s "${WORKDIR}"/pg-data \
		-d "${D}"/usr/share/${PN} || die

	doicon -s 48 lgeneral.png
	make_desktop_entry ${PN} LGeneral
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
