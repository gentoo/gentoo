# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MATE_LA_PUNT="yes"

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
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
	dev-util/gtk-doc-am
	>=sys-devel/gettext-0.19.8
	>=sys-devel/libtool-2.2.6:2
	virtual/pkgconfig
"

src_configure() {
	mate_src_configure \
		--enable-locations-compression \
		--disable-all-translations-in-one-xml \
		--disable-icon-update
}
