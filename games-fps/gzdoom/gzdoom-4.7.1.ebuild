# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop xdg flag-o-matic

DESCRIPTION="A modder-friendly OpenGL source port based on the DOOM engine"
HOMEPAGE="https://zdoom.org"
SRC_URI="https://github.com/coelckers/${PN}/archive/g${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BZIP2 GPL-3 LGPL-2.1+ LGPL-3 MIT
	non-free? ( Activision ChexQuest3 DOOM-COLLECTORS-EDITION freedist WidePix )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug gles2 gtk +non-free openmp telemetry vulkan"

DEPEND="
	app-arch/bzip2
	media-libs/libsdl2[gles2?,opengl,vulkan?]
	media-libs/openal
	media-libs/zmusic
	sys-libs/zlib
	virtual/jpeg:0
	gtk? ( x11-libs/gtk+:3 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-g${PV}"

PATCHES=(
	"${FILESDIR}/${P}-Introduce-the-BUILD_NONFREE-option.patch"
)

src_prepare() {
	rm -rf docs/licenses || die
	rm -rf libraries/{bzip2,jpeg,zlib} || die
	if ! use non-free ; then
		rm -rf wadsrc_bm wadsrc_extra wadsrc_widepix || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_DOCS_PATH="${EPREFIX}/usr/share/doc/${PF}"
		-DINSTALL_PK3_PATH="${EPREFIX}/usr/share/doom"
		-DINSTALL_SOUNDFONT_PATH="${EPREFIX}/usr/share/doom"
		-DDYN_OPENAL=OFF
		-DNO_GTK="$(usex !gtk)"
		-DNO_OPENAL=OFF
		-DHAVE_VULKAN="$(usex vulkan)"
		-DHAVE_GLES2="$(usex gles2)"
		-DNO_OPENMP="$(usex !openmp)"
		-DBUILD_NONFREE="$(usex non-free)"
	)

	use debug || append-cppflags -DNDEBUG
	use telemetry || append-cppflags -DNO_SEND_STATS

	cmake_src_configure
}

src_install() {
	newicon src/posix/zdoom.xpm "${PN}.xpm"
	make_desktop_entry "${PN}" "GZDoom" "${PN}" "Game;ActionGame"
	cmake_src_install
}

pkg_postinst() {
	xdg_pkg_postinst

	if ! use non-free ; then
		ewarn
		ewarn "GZDoom installed without non-free components."
		ewarn "Note: The non-free game_support.pk3 file is needed to play"
		ewarn "      games natively supported by GZDoom."
		ewarn "A list of games natively supported by GZDoom is available"
		ewarn "on the ZDoom wiki: https://zdoom.org/wiki/IWAD"
		ewarn
	fi
}
