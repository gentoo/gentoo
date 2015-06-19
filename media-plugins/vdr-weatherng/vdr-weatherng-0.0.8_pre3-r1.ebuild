# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-weatherng/vdr-weatherng-0.0.8_pre3-r1.ebuild,v 1.4 2015/03/05 18:30:36 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="VDR plugin: show weather for specified place"
HOMEPAGE="http://www.vdr.glaserei-franz.de/vdrplugins.htm"
SRC_URI="mirror://vdrfiles/${PN}/${MY_P}.tgz"

LICENSE="GPL-2 stardock-images"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dxr3"

DEPEND="media-libs/imlib2[jpeg,gif]
	>=media-video/vdr-1.3.34"
RDEPEND="${DEPEND}"

S="${WORKDIR}/weatherng-${MY_PV}"

VDR_CONFD_FILE="${FILESDIR}/confd-0.0.8"
VDR_RCADDON_FILE="${FILESDIR}/rc-addon-0.0.8.sh"

PATCHES=("${FILESDIR}/${P}-i18n-fix.diff")

src_prepare() {
	vdr-plugin-2_src_prepare

	epatch "${FILESDIR}/${P}-gentoo.diff"
	epatch "${FILESDIR}/${P}-timeout.diff"
	epatch "${FILESDIR}/${P}-gcc43.patch"

	use dxr3 && epatch "${FILESDIR}/${P}-dxr3.diff"

	# /bin/sh is not necessaryly bash, so explicitly use /bin/bash
	sed -e 's#/bin/sh#/bin/bash#' -i examples/weatherng.sh

	sed -i weatherng.c -e "s:RegisterI18n://RegisterI18n:"
}

src_install() {
	vdr-plugin-2_src_install

	insinto /usr/share/vdr/weatherng/images
	doins "${S}"/images/*.png

	diropts -m0755 -ovdr -gvdr
	dodir /var/vdr/${VDRPLUGIN}

	insinto  /var/vdr/${VDRPLUGIN}
	insopts -m755 -ovdr -gvdr
	doins "${S}"/examples/weatherng.sh
}

pkg_postinst() {
	vdr-plugin-2_pkg_postinst

	echo
	elog "To display the weather for your location"
	elog "you have to find out its ID on weather.com"
	elog
	elog "Go to http://uk.weather.com/search/drilldown/ and search for your city (i.e. Herne)"
	elog "in the list of results click on the right one and then look at its URL"
	elog
	elog "It contains a code for your city"
	elog "For Herne this is GMXX0056"
	elog
	elog "Now you have to enter this code in /etc/conf.d/vdr.weatherng WEATHERNG_STATIONID(x)"
	echo
}
