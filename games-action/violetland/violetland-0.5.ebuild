# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop xdg-utils

DESCRIPTION="Help a girl named Violet in the struggle with hordes of monsters"
HOMEPAGE="https://violetland.github.io/"
SRC_URI="https://github.com/ooxi/${PN}/releases/download/${PV}/${P}-source-with-dependencies.tar.gz"

LICENSE="GPL-3 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/boost:=[threads(+)]
	media-libs/libsdl[sound,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf
	virtual/opengl
"

DEPEND="${RDEPEND}"

BDEPEND="
	sys-devel/gettext
"

src_prepare() {
	cmake_src_prepare

	# Bizarrely fcitx is only bundled for a CMake module to find libintl
	# but let's make sure the rest remains unused.
	rm -r lib/fcitx/src || die
}

src_configure() {
	local mycmakeargs=(
		-DDATA_INSTALL_DIR="${EPREFIX}/usr/share/${PN}"
		-DLOCALE_INSTALL_DIR=share/locale
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	dodoc CHANGELOG.md CONTRIBUTORS.md

	# Remove duplicate READMEs.
	rm -r "${ED}"/usr/share/${PN}/README* || die

	newicon -s 64 icon-light.png ${PN}.png
	make_desktop_entry ${PN} VioletLand
}

pkg_postinst() { xdg_icon_cache_update; }
pkg_postrm() { xdg_icon_cache_update; }
