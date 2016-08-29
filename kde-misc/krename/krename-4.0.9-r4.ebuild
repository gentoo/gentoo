# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_LINGUAS="bs cs de el es fr hu it ja lt nl pl pt ru sl sv tr uk zh_CN"
inherit kde4-base

DESCRIPTION="KRename - a very powerful batch file renamer"
HOMEPAGE="http://www.krename.net/"
SRC_URI="mirror://sourceforge/krename/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug exif pdf taglib truetype"

RDEPEND="
	exif? ( >=media-gfx/exiv2-0.13:= )
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
	"${FILESDIR}/${P}-gcc6.patch"
)
DOCS=( AUTHORS README TODO )

src_configure() {
	local mycmakeargs=(
		-DWITH_Exiv2=$(usex exif)
		-DWITH_Taglib=$(usex taglib)
		-DWITH_LIBPODOFO=$(usex pdf)
		-DWITH_Freetype=$(usex truetype)
	)

	kde4-base_src_configure
}
