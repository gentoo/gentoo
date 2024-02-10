# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools

DESCRIPTION="Tomoe GTK+ interface widget library"
HOMEPAGE="http://tomoe.osdn.jp/"
SRC_URI="mirror://sourceforge/tomoe/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="app-i18n/tomoe
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/glib-utils
	dev-build/gtk-doc-am
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-math.patch )

AT_M4DIR="macros"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--without-python \
		--without-gucharmap
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}
