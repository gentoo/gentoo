# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools xdg

DESCRIPTION="A collection of data files to add support for chemical MIME types"
HOMEPAGE="https://github.com/dleidert/chemical-mime"
SRC_URI="mirror://sourceforge/${PN/-data/}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86"
IUSE=""

RDEPEND="
	gnome-base/gnome-mime-data
	x11-misc/shared-mime-info"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/desktop-file-utils
	dev-libs/libxslt
	|| (
		gnome-base/librsvg
		media-gfx/imagemagick[xml,png,svg]
	)
	media-gfx/imagemagick[png]
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-turbomole.patch
	"${FILESDIR}"/${P}-pigz.patch
	"${FILESDIR}"/${P}-namespace-svg.patch
	"${FILESDIR}"/${P}-rsvg-convert.patch
	)

src_prepare() {
	xdg_src_prepare
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-update-database
		--htmldir=/usr/share/doc/${PF}/html
		)
	econf ${myeconfargs[@]}
}
