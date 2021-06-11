# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0"
inherit cmake wxwidgets

MY_PN="LogbookKonni-1.2"
if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/delatbabel/${MY_PN}.git"
else
	SRC_URI="
		https://github.com/delatbabel/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/delatbabel/${MY_PN}/releases/download/v${PV}/LogbookKonni_Layouts.zip -> ${P}_Layouts.zip"

	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

DESCRIPTION="Logbook Plugin for OpenCPN"
HOMEPAGE="https://github.com/delatbabel/LogbookKonni-1.2"

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}
	>=sci-geosciences/opencpn-4.2.0
	sys-devel/gettext"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/zip
	sys-devel/gettext"

src_configure() {
	setup-wxwidgets unicode
	cmake_src_configure
}

src_install() {
	# install layouts as zip
	cmake_src_install

	cd "${WORKDIR}" || die
	zip -r "${ED}"/usr/share/opencpn/plugins/logbookkonni_pi/data/LogbookKonni_Layouts.zip Clouds HTMLLayouts ODTLayouts || die
}

pkg_postinst() {
	elog "Installation of logbook layouts"
	elog "*******************************"
	elog
	elog "The default layouts zip file has been installed to:"
	elog "${EROOT}/usr/share/opencpn/plugins/logbookkonni_pi/data/LogbookKonni_Layouts.zip"
	elog
	elog "After starting OpenCPN, go to Options->Plugins->Logbook->Settings,"
	elog "click the install button and choose the above mentioned zip file"
	elog
}
