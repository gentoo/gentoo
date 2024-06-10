# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop toolchain-funcs xdg

DESCRIPTION="A MMORPG based on the works of J.R.R. Tolkien"
HOMEPAGE="https://www.tomenet.eu"
SRC_URI="https://www.tomenet.eu/downloads/${P}.tar.bz2"

LICENSE="Moria"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+client server +sound X"
REQUIRED_USE="|| ( client server )"

RDEPEND="sys-libs/ncurses:0
	client? (
		X? (
			x11-libs/libX11
		)
		sound? (
			media-libs/libsdl[sound]
			media-libs/sdl-mixer[vorbis,smpeg,mp3]
		)
	)"
DEPEND="${RDEPEND}
	client? ( sound? ( app-arch/p7zip ) )"
BDEPEND="virtual/pkgconfig"

S=${WORKDIR}/${P}/src

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-disable-experimental.patch
)

src_prepare() {
	default
	if ! use server; then
		rm -r ../lib/{config,data,save} || die
	fi

	sed \
		-e "s#@LIBDIR@#${EPREFIX}/usr/share/${PN}#" \
		"${FILESDIR}"/${PN}-wrapper > "${T}"/${PN} || die

	if use server; then
		sed \
			-e "s#@LIBDIR@#${EPREFIX}/usr/share/${PN}#" \
			"${FILESDIR}"/${PN}-server-wrapper > "${T}"/${PN}.server || die
	fi

	tc-export PKG_CONFIG
}

src_compile() {
	local mytargets="$(usex client "tomenet" "") $(usex server "accedit tomenet.server" "")"
	emake \
		$(usex client "$(usex X "USE_X=1" "")" "") \
		$(usex client "$(usex sound "USE_SDL=1" "")" "") \
		CC="$(tc-getCC)" \
		CPP="$(tc-getCPP)" \
		GENTOO_CPPFLAGS="${CPPFLAGS}" \
		-f makefile \
		${mytargets[@]}
}

src_install() {
	dodoc ../TomeNET-Guide.txt

	if use client ; then
		newbin ${PN} ${PN}.bin
		dobin "${T}"/${PN}

		doicon -s 48 client/tomenet4.png
		make_desktop_entry ${PN} ${PN} ${PN}4
	fi

	if use server ; then
		newbin tomenet.server tomenet.server.bin
		dobin "${T}"/${PN}.server accedit
	fi

	insinto "/usr/share/${PN}"
	doins -r ../lib/*
	doins ../.tomenetrc
}

pkg_postinst() {
	xdg_pkg_postinst

	if use sound; then
		elog "You can get soundpacks from here:"
		elog '  https://tomenet.eu/downloads.php'
		elog "They must be placed inside ~/.tomenet directory."
	fi
}
