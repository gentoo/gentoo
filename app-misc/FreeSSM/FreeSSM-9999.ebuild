# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils desktop

DESCRIPTION="Free and easy to use diagnostic and adjustment tool for SUBARU vehicles"
HOMEPAGE="https://github.com/Comer352L/FreeSSM"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Comer352L/FreeSSM.git"
else
	COMMIT="1a0fa0934581b3383adfd2722050503695ca9dab"
	SRC_URI="https://github.com/Comer352L/FreeSSM/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="small-resolution"

RDEPEND="
	dev-qt/qtbase:6[gui,widgets]
	media-libs/libglvnd
"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]"

src_configure() {
	eqmake6 FreeSSM.pro $(usex small-resolution CONFIG+=small-resolution "")
}

src_compile() {
	emake release
	emake translation
}

src_install() {
	local installdir="/usr/share/${PN}"

	eqmake6 INSTALLDIR="${D}${installdir}"
	emake release-install

	make_desktop_entry "${installdir}/${PN}" ${PN} "${installdir}/${PN}.png"
}
