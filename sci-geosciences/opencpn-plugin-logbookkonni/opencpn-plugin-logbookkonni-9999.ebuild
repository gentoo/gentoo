# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

WX_GTK_VER="3.0"
MY_PN="LogbookKonni-1.2"
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/delatbabel/${MY_PN}.git"
	inherit git-r3 cmake-utils wxwidgets
else
	SRC_URI="
		https://github.com/delatbabel/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/delatbabel/${MY_PN}/releases/download/v${PV}/LogbookKonni_Layouts.zip -> ${P}_Layouts.zip
	"
	inherit cmake-utils wxwidgets
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

DESCRIPTION="Logbook Plugin for OpenCPN"
HOMEPAGE="https://github.com/delatbabel/LogbookKonni-1.2"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

RDEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}
	>=sci-geosciences/opencpn-4.2.0
	sys-devel/gettext
"
DEPEND="
	app-arch/zip
	${RDEPEND}
"

src_prepare() {
	need-wxwidgets unicode
	cmake-utils_src_prepare
}

src_install() {
	# install layouts as zip
	cmake-utils_src_install
	cd "${WORKDIR}" || die
	zip -r "${D}"/usr/share/opencpn/plugins/logbookkonni_pi/data/LogbookKonni_Layouts.zip Clouds HTMLLayouts ODTLayouts || die
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
