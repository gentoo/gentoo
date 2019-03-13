# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils gnome2-utils toolchain-funcs

DESCRIPTION="A MMORPG based on the works of J.R.R. Tolkien"
HOMEPAGE="https://www.tomenet.eu"
SRC_URI="https://www.tomenet.eu/downloads/${P}.tar.bz2"

LICENSE="Moria"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated server +sound X"

RDEPEND="sys-libs/ncurses:0
	!dedicated? (
		X? (
			x11-libs/libX11
		)
		sound? (
			media-libs/libsdl[sound]
			media-libs/sdl-mixer[vorbis,smpeg,mp3]
		)
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	!dedicated? ( sound? ( app-arch/p7zip[wxwidgets] ) )"

S=${WORKDIR}/${P}/src

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
)

src_prepare() {
	default
	use server || use dedicated || { rm -r ../lib/{config,data,save} || die ;}

	sed \
		-e "s#@LIBDIR@#/usr/share/${PN}#" \
		"${FILESDIR}"/${PN}-wrapper > "${T}"/${PN} || die

	if use server || use dedicated ; then
		sed \
			-e "s#@LIBDIR@#/usr/share/${PN}#" \
			"${FILESDIR}"/${PN}-server-wrapper > "${T}"/${PN}.server || die
	fi

	tc-export PKG_CONFIG
}

src_compile() {
	local mytargets="$(usex dedicated "accedit tomenet.server" "$(usex server "all" "tomenet")")"
	emake \
		$(usex dedicated "" "$(usex X "USE_X=1" "")") \
		$(usex dedicated "" "$(usex sound "USE_SDL=1" "")") \
		-f makefile \
		${mytargets[@]}
}

src_install() {
	dodoc ../TomeNET-Guide.txt

	if ! use dedicated ; then
		newbin ${PN} ${PN}.bin
		dobin "${T}"/${PN}

		doicon -s 48 client/tomenet4.png
		make_desktop_entry ${PN} ${PN} ${PN}4
	fi

	if use server || use dedicated ; then
		newbin tomenet.server tomenet.server.bin
		dobin "${T}"/${PN}.server accedit
	fi

	insinto "/usr/share/${PN}"
	doins -r ../lib/*
	doins ../.tomenetrc
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update

	if use sound; then
		elog "You can get soundpacks from here:"
		elog '  https://tomenet.net/downloads.php'
		elog "They must be placed inside ~/.tomenet directory."
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
}
