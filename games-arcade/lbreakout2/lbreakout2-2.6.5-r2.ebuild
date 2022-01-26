# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

LB_LEVELS_V="20141220"
LB_THEMES_V="20141220"

DESCRIPTION="Breakout clone written with the SDL library"
HOMEPAGE="https://lgames.sourceforge.io/LBreakout2/"
SRC_URI="
	mirror://sourceforge/lgames/${P}.tar.gz
	mirror://sourceforge/lgames/add-ons/lbreakout2/${PN}-levelsets-${LB_LEVELS_V}.tar.gz
	themes? ( mirror://sourceforge/lgames/add-ons/lbreakout2/${PN}-themes-${LB_LEVELS_V}.tar.gz )"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls themes"

RDEPEND="
	acct-group/gamestat
	media-libs/libpng:=
	media-libs/libsdl[joystick,sound,video]
	media-libs/sdl-mixer
	media-libs/sdl-net
	nls? ( virtual/libintl )"
DEPEND="
	${RDEPEND}
	sys-libs/zlib"
BDEPEND="
	nls? ( sys-devel/gettext )
	themes? ( app-arch/unzip )"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
)

src_unpack() {
	unpack ${P}.tar.gz

	cd "${S}/client/levels" || die
	unpack ${PN}-levelsets-${LB_LEVELS_V}.tar.gz

	if use themes; then
		mkdir "${WORKDIR}"/themes || die
		cd "${WORKDIR}"/themes || die
		unpack ${PN}-themes-${LB_THEMES_V}.tar.gz

		# Delete a few duplicate themes (already shipped with lbreakout2
		# tarball). Some of them have different case than built-in themes, so it
		# is harder to just compare if the filename is the same.
		rm absoluteB.zip oz.zip moiree.zip || die
		local f
		for f in *.zip; do
			unpack ./${f}
			rm ${f} || die
		done
	fi
}

src_prepare() {
	default

	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	local econfargs=(
		$(use_enable nls)
		--enable-sdl-net
		--localstatedir="${EPREFIX}"/var/games
		--with-docdir="${EPREFIX}"/usr/share/doc/${PF}/html
	)
	econf "${econfargs[@]}"
}

src_install() {
	default

	fowners :gamestat /usr/bin/${PN} /var/games/${PN}.hscr
	fperms g+s /usr/bin/${PN}
	fperms 660 /var/games/${PN}.hscr

	if use themes; then
		insinto /usr/share/lbreakout2/gfx
		doins -r "${WORKDIR}"/themes/.
	fi

	newicon client/gfx/win_icon.png ${PN}.png
	make_desktop_entry ${PN} LBreakout2
}
