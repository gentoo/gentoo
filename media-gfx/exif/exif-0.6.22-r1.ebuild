# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Small CLI util to show EXIF infos hidden in JPEG files"
HOMEPAGE="https://libexif.github.io/ https://github.com/libexif/exif"
SRC_URI="https://github.com/lib${PN}/${PN}/releases/download/${PN}-${PV//./_}-release/${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="nls"

BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
DEPEND="
	dev-libs/popt
	>=media-libs/libexif-${PV}
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-empty-string-check.patch
)

src_configure() {
	econf $(use_enable nls)
}
