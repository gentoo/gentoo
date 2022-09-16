# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils desktop

DESCRIPTION="Free and easy to use diagnostic and adjustment tool for SUBARU® vehicles"
HOMEPAGE="https://github.com/Comer352L/FreeSSM"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Comer352L/FreeSSM.git"
else
	SRC_URI="https://github.com/Comer352L/FreeSSM/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="small-resolution"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	media-libs/libglvnd
"
DEPEND="
	${RDEPEND}
	dev-qt/linguist-tools:5
"

src_configure() {
	eqmake5 FreeSSM.pro $(usex small-resolution CONFIG+=small-resolution "")
}

src_compile() {
	emake release
	emake translation
}

src_install() {
	local installdir="/usr/share/${PN}"

	eqmake5 INSTALLDIR="${D}${installdir}"
	emake release-install

	make_desktop_entry "${installdir}/${PN}" ${PN} "${installdir}/${PN}.png"
}
