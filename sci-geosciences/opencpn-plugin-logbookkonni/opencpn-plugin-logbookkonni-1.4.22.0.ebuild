# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0-gtk3"
inherit cmake wxwidgets

MY_PN="LogbookKonni_pi"
if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rgleason/${MY_PN}.git"
else
	SRC_URI="https://github.com/rgleason/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

DESCRIPTION="Logbook Plugin for OpenCPN"
HOMEPAGE="https://github.com/rgleason/LogbookKonni_pi"

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}
	sci-geosciences/opencpn:=
	sys-devel/gettext"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/zip
	sys-devel/gettext"

PATCHES=(
	"${FILESDIR}/cmake.patch"
)

src_configure() {
	setup-wxwidgets unicode
	cmake_src_configure
}

pkg_postinst() {
	elog "Installation of logbook layouts"
	elog "*******************************"
	elog
	elog "The default layouts zip file has been installed to:"
	elog "${EROOT}/usr/share/opencpn/plugins/logbookkonni_pi/data/Layouts.zip"
	elog
	elog "After starting OpenCPN, go to Options->Plugins->Logbook->Settings,"
	elog "click the install button and choose the above mentioned zip file"
	elog
}
