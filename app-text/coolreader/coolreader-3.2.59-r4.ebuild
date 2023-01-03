# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
WX_GTK_VER="3.0-gtk3"
PLOCALES="bg cs de es hu pl ru uk"
inherit cmake plocale wxwidgets xdg

CR_PV=$(ver_rs 3 '-')
SRC_URI="https://github.com/buggins/${PN}/archive/cr${CR_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-cr${CR_PV}"

DESCRIPTION="CoolReader - reader of eBook files (fb2,epub,htm,rtf,txt)"
HOMEPAGE="https://github.com/buggins/coolreader/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="wxwidgets"

CDEPEND="sys-libs/zlib
	app-arch/zstd:=
	media-libs/libpng:0
	media-libs/libjpeg-turbo
	media-libs/freetype
	dev-libs/fribidi
	media-libs/fontconfig
	media-libs/harfbuzz:=
	dev-libs/libunibreak:=
	dev-libs/libutf8proc:=
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )
	!wxwidgets? ( dev-qt/qtcore:5 dev-qt/qtgui:5 dev-qt/qtwidgets:5 )"
BDEPEND="${CDEPEND}
	!wxwidgets? ( dev-qt/linguist-tools:5 )"
RDEPEND="${CDEPEND}
	wxwidgets? ( || ( media-fonts/liberation-fonts media-fonts/corefonts ) )"

PATCHES=( "${FILESDIR}"/${PN}-wxwidgets.patch )

src_prepare() {
	cmake_src_prepare
	xdg_environment_reset

	# locales
	plocale_find_changes "${S}"/cr3qt/src/i18n 'cr3_' '.ts'
	sed -e "s|SET(LANGUAGES .*)|SET(LANGUAGES $(plocale_get_locales))|" \
		-i "${S}"/cr3qt/CMakeLists.txt \
		|| die "sed CMakeLists.txt failed"
}

src_configure() {
	CMAKE_USE_DIR="${S}"
	CMAKE_BUILD_TYPE="Release"
	if use wxwidgets; then
		setup-wxwidgets
		local mycmakeargs=(-DGUI=WX)
	else
		local mycmakeargs=(-DGUI=QT5)
	fi
	cmake_src_configure
}

src_install() {
	cmake_src_install
	if ! use wxwidgets; then
		mv "${D}"/usr/share/doc/cr3/changelog.gz "${D}"/usr/share/doc/${PF}/ || die "mv changelog.gz failed"
		rmdir "${D}"/usr/share/doc/cr3 || die "rmdir doc/cr3 failed"
		gunzip "${D}"/usr/share/doc/${PF}/changelog.gz || die "gunzip changelog.gz failed"
		gunzip "${D}"/usr/share/man/man1/cr3.1.gz || die "gunzip cr3.1.gz failed"
	fi
}
