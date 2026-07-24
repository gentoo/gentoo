# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs xdg

DESCRIPTION="MMORPG based on the works of J.R.R. Tolkien"
HOMEPAGE="https://www.tomenet.eu"
SRC_URI="https://www.tomenet.eu/downloads/${P}.tar.bz2"
S="${WORKDIR}"/${P}/src

LICENSE="Moria"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+client server +sound X"
REQUIRED_USE="|| ( client server )"

RDEPEND="
	sys-libs/ncurses:=
	client? (
		X? (
			x11-libs/libX11
		)
		sound? (
			media-libs/libsdl2[sound]
			media-libs/sdl2-mixer[vorbis,mp3]
		)
	)
	server? (
		virtual/libcrypt:=
	)
"
DEPEND="${RDEPEND}"
RDEPEND+="
	client? (
		sound? (
			|| (
				>=app-arch/7zip-24.09[symlink(+)]
				app-arch/p7zip
			)
		)
	)
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-4.9.3-makefile.patch
	"${FILESDIR}"/${PN}-4.9.1-disable-experimental.patch
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
	# TODO: Is libsdl2 really only needed with sound / is the patch to the
	# Makefile correct?
	local mytargets=(
		$(usev client 'tomenet')
		$(usev server 'accedit tomenet.server')
	)

	emake -f makefile \
		$(usev client $(usev X 'USE_X=1')) \
		$(usev client $(usev sound 'USE_SDL=1')) \
		CC="$(tc-getCC)" \
		CPP="$(tc-getCPP)" \
		GENTOO_CPPFLAGS="${CPPFLAGS}" \
		"${mytargets[@]}"
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

	insinto /usr/share/${PN}
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
