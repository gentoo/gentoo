# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} != *9999* ]]; then
	KDSOAP_COMMIT=8fde0425e38bf58922b6054768b4a7e5f349500b
	LIBKODE_COMMIT=dfe0d565cb58cfb25da77853d9694097aa8e5882
	SRC_URI="https://github.com/KDAB/KDSoap/archive/${KDSOAP_COMMIT}.tar.gz -> ${P}.tar.gz
		https://github.com/cornelius/libkode/archive/${LIBKODE_COMMIT}.tar.gz -> ${P}-libkode-${LIBKODE_COMMIT}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64"
	S="${WORKDIR}/KDSoap-${KDSOAP_COMMIT}"
else
	EGIT_REPO_URI="https://github.com/KDAB/KDSoap.git"
	EGIT_SUBMODULES=( kdwsdl2cpp/libkode -autogen )
	inherit git-r3
fi
inherit cmake

DESCRIPTION="Qt-based client-side and server-side SOAP component"
HOMEPAGE="https://www.kdab.com/development-resources/qt-tools/kd-soap/"

LICENSE="GPL-3 AGPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	dev-qt/qtxml:5
"
DEPEND="${RDEPEND}
	dev-libs/boost
"

src_prepare() {
	rmdir kdwsdl2cpp/libkode || die
	mv "${WORKDIR}"/libkode-${LIBKODE_COMMIT} "${S}"/kdwsdl2cpp/libkode || die

	cmake_src_prepare

	sed -e "/^find_package.*Qt5/s/Widgets //" \
		-e "/install.*INSTALL_DOC_DIR/d" \
		-i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DKDSoap_EXAMPLES=OFF # Qt4-based and no install targets
	)
	cmake_src_configure
}
