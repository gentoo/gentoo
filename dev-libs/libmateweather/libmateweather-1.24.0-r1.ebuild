# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MATE_LA_PUNT="yes"

inherit eapi7-ver mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

DESCRIPTION="MATE library to access weather information from online services"
LICENSE="LGPL-2.1+ GPL-2+"
SLOT="0"

IUSE="debug"

COMMON_DEPEND=">=dev-libs/glib-2.50:2
	>=dev-libs/libxml2-2.6:2
	>=net-libs/libsoup-2.54:2.4
	>=sys-libs/timezone-data-2010k:0
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3"

RDEPEND="${COMMON_DEPEND}
	virtual/libintl
"

DEPEND="${COMMON_DEPEND}
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=sys-devel/gettext-0.19.8:*
	>=sys-devel/libtool-2.2.6:2
	virtual/pkgconfig:*
"

PATCHES=()

src_prepare() {
	local tz_ver=$(best_version sys-libs/timezone-data)
	tz_ver=${tz_ver#sys-libs/timezone-data-}
	if $(ver_test "${tz_ver}" -ge "2020a" ); then
		PATCHES+=( "${FILESDIR}/${P}-fix-tzdata-hints.patch" )
	fi
	mate_src_prepare
}

src_configure() {
	mate_src_configure \
		--enable-locations-compression \
		--disable-all-translations-in-one-xml \
		--disable-icon-update
}
