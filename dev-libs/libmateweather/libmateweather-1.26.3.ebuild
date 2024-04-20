# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MATE_LA_PUNT="yes"

inherit mate

MINOR=$(($(ver_cut 2) % 2))
if [[ ${MINOR} -eq 0 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~loong ~riscv x86"
fi

DESCRIPTION="MATE library to access weather information from online services"
LICENSE="LGPL-2.1+ GPL-2+"
SLOT="0"

IUSE="debug"

COMMON_DEPEND=">=dev-libs/glib-2.56:2
	>=dev-libs/libxml2-2.6:2
	>=net-libs/libsoup-2.54:2.4
	>=sys-libs/timezone-data-2010k:0
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3
"

RDEPEND="${COMMON_DEPEND}
	virtual/libintl
"

DEPEND="${RDEPEND}"

BDEPEND="
	dev-util/gtk-doc
	dev-build/gtk-doc-am
	>=sys-devel/gettext-0.19.8
	>=dev-build/libtool-2.2.6:2
	virtual/pkgconfig
"

src_configure() {
	mate_src_configure \
		--enable-locations-compression \
		--disable-all-translations-in-one-xml \
		--disable-icon-update
}
