# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="Batch image converter and resizer based on ImageMagick"
HOMEPAGE="https://converseen.fasterland.net/
	https://github.com/Faster3ck/Converseen/"
SRC_URI="https://github.com/Faster3ck/Converseen/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="graphicsmagick debug"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	graphicsmagick? ( media-gfx/graphicsmagick:=[cxx,imagemagick] )
	!graphicsmagick? ( media-gfx/imagemagick:=[cxx] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/linguist-tools:5
"

S="${WORKDIR}/${P^}"

PATCHES=(
	"${FILESDIR}/${PN}-0.9.9.0-appdata-path.patch"
	"${FILESDIR}/${PN}-0.9.9.0-no-update.patch"
	"${FILESDIR}/${P}-graphicsmagick-support.patch"
)

src_prepare() {
	cmake_src_prepare

	if use graphicsmagick; then
		# Replace variables in CMakeLists.txt
		sed -i -e "s/GENTOO_LIB/\/usr\/$(get_libdir)/g" \
				-e "s/GENTOO_INCLUDE/\/usr\/include/g" \
				"${S}/CMakeLists.txt" ||
			die "Failed to sed graphicsmagick patch"

		# Replace MagickCore in globals.cpp
		sed -i -e "s/MagickCore/MagickLib/" "${S}/src/globals.cpp" ||
			die "Failed to sed globals.cpp"
	fi
}

pkg_postinst() {
	elog "Please note that due to security policy restrictions"
	elog "on media-gfx/imagemagick the support for PS, PDF and"
	elog "XPS files must be explicitly enabled by commenting out"
	elog "the respective policies in /etc/ImageMagick-7/policy.xml."
	elog "See https://wiki.gentoo.org/wiki/ImageMagick#Troubleshooting"
	elog "for more information."

	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
