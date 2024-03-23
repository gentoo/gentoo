# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Japanese input method Tomoe IMEngine for SCIM"
HOMEPAGE="http://tomoe.sourceforge.net/"
SRC_URI="mirror://sourceforge/tomoe/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=app-i18n/scim-1.2.0
	>=app-i18n/tomoe-gtk-0.6.0
	>=x11-libs/gtk+-2.4:2
	dev-libs/libltdl
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	>=dev-util/intltool-0.35.0
"

PATCHES=( "${FILESDIR}"/${P}-gcc43.patch )

src_prepare() {
	default
	# update the 2007 era configure / libtool scripts, which fail with LTO
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
