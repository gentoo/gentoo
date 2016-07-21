# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="3.0"
inherit cmake-utils wxwidgets

MY_PN="LogbookKonni-1.2"

DESCRIPTION="Logbook Plugin for OpenCPN"
HOMEPAGE="http://opencpn.org/ocpn/downloadplugins"
SRC_URI="https://github.com/delatbabel/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/delatbabel/${MY_PN}/releases/download/v${PV}/LogbookKonni_Layouts.zip -> ${P}_Layouts.zip
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=sci-geosciences/opencpn-4.0.0
	<sci-geosciences/opencpn-4.2.0
	sys-devel/gettext
	x11-libs/wxGTK:${WX_GTK_VER}
"
DEPEND="
	app-arch/zip
	${RDEPEND}
"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	need-wxwidgets unicode
	cmake-utils_src_prepare
}

src_install() {
	# install layouts as zip
	cmake-utils_src_install
	cd "$WORKDIR"
	zip -r "$D"/usr/share/opencpn/plugins/logbookkonni_pi/data/LogbookKonni_Layouts.zip Clouds HTMLLayouts ODTLayouts
}

pkg_postinst() {
	elog "Installation of logbook layouts"
	elog "*******************************"
	elog ""
	elog "The default layouts zip file has been installed to:"
	elog "/usr/share/opencpn/plugins/logbookkonni_pi/data/LogbookKonni_Layouts.zip"
	elog ""
	elog "After starting OpenCPN, go to Options->Plugins->Logbook->Settings,"
	elog "click the install button and choose the above mentioned zip file"
	elog ""
}
