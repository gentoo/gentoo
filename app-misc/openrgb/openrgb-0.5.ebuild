# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI=${EGIT_REPO_URI:-"https://gitlab.com/CalcProgrammer1/OpenRGB"}
else
	SRC_URI="https://gitlab.com/CalcProgrammer1/OpenRGB/-/archive/release_${PV}/OpenRGB-release_${PV}.tar.bz2"
	S="${WORKDIR}/OpenRGB-release_${PV}"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Open source RGB lighting control that doesn't depend on manufacturer software"
HOMEPAGE="https://gitlab.com/CalcProgrammer1/OpenRGB/"
LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	dev-libs/hidapi:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	virtual/libusb:1
"
DEPEND="
	${RDEPEND}
	dev-cpp/nlohmann_json
"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	default
	rm -r dependencies/{hidapi,libusb,json}* || die
	if [[ ${PV} != *9999* ]]; then
		eapply "${FILESDIR}/OpenRGB-0.5-build-system.patch"
	fi
}

src_configure() {
	eqmake5 INCLUDEPATH+="${ESYSROOT}/usr/include/nlohmann"
}

src_install() {
	emake INSTALL_ROOT="${ED}" install

	dodoc README.md OpenRGB.patch
}
