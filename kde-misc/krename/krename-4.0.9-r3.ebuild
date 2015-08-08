# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS="bs cs de el es fr hu it ja lt nl pl pt ru sl sv tr uk zh_CN"
inherit kde4-base

DESCRIPTION="KRename - a very powerful batch file renamer"
HOMEPAGE="http://www.krename.net/"
SRC_URI="mirror://sourceforge/krename/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug exif pdf taglib truetype"

RDEPEND="
	exif? ( >=media-gfx/exiv2-0.13 )
	pdf? ( >=app-text/podofo-0.8 )
	taglib? ( >=media-libs/taglib-1.5 )
	truetype? ( media-libs/freetype:2 )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

PATCHES=(
	"${FILESDIR}/${P}-freetype-include.patch"
	"${FILESDIR}/${P}-desktop-file.patch"
)
DOCS=( AUTHORS README TODO )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with exif Exiv2)
		$(cmake-utils_use_with taglib)
		$(cmake-utils_use_with pdf LIBPODOFO)
		$(cmake-utils_use_with truetype Freetype)
	)

	kde4-base_src_configure
}
