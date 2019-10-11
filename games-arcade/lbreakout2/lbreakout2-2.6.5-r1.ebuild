# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools desktop flag-o-matic gnome2-utils

levels_V=20141220
themes_V=20141220

DESCRIPTION="Breakout clone written with the SDL library"
HOMEPAGE="http://lgames.sourceforge.net/LBreakout2/"
SRC_URI=" mirror://sourceforge/lgames/${P}.tar.gz
	mirror://sourceforge/lgames/add-ons/lbreakout2/${PN}-levelsets-${levels_V}.tar.gz
	themes? ( mirror://sourceforge/lgames/add-ons/lbreakout2/${PN}-themes-${levels_V}.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls themes"

RDEPEND="
	media-libs/libpng:0=
	sys-libs/zlib
	media-libs/libsdl[sound,joystick,video]
	media-libs/sdl-net
	media-libs/sdl-mixer
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
"

src_unpack() {
	unpack ${P}.tar.gz

	cd "${S}/client/levels"
	unpack ${PN}-levelsets-${levels_V}.tar.gz

	if use themes ; then
		mkdir "${WORKDIR}/themes"
		cd "${WORKDIR}/themes"
		unpack ${PN}-themes-${themes_V}.tar.gz

		# Delete a few duplicate themes (already shipped with lbreakout2
		# tarball). Some of them have different case than built-in themes, so it
		# is harder to just compare if the filename is the same.
		rm -f absoluteB.zip oz.zip moiree.zip
		for f in *.zip; do
			unzip -q "$f"  &&  rm -f "$f" || die
		done
	fi
}

src_prepare() {
	default
	eapply "${FILESDIR}"/${P}-gentoo.patch
	eautoreconf
}

src_configure() {
	filter-flags -O?
	econf \
		--enable-sdl-net \
		--localedir=/usr/share/locale \
		--with-docdir="/usr/share/doc/${PF}/html" \
		$(use_enable nls)
}

src_install() {
	default

	if use themes ; then
		insinto /usr/share/lbreakout2/gfx
		doins -r "${WORKDIR}/themes/"*
	fi

	newicon client/gfx/win_icon.png ${PN}.png
	newicon -s 32 client/gfx/win_icon.png ${PN}.png
	make_desktop_entry lbreakout2 LBreakout2
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
