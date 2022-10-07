# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999* ]]; then
	SRC_URI="https://github.com/KDAB/KDSoap/releases/download/${P}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
else
	EGIT_REPO_URI="https://github.com/KDAB/KDSoap.git"
	EGIT_SUBMODULES=( kdwsdl2cpp/libkode -autogen )
	inherit git-r3
fi
inherit cmake

DESCRIPTION="Qt-based client-side and server-side SOAP component"
HOMEPAGE="https://www.kdab.com/development-resources/qt-tools/kd-soap/"

LICENSE="GPL-3 AGPL-3"
SLOT="0/2"
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
	cmake_src_prepare
	sed -e "/install.*INSTALL_DOC_DIR/d" -i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DKDSoap_DOCS=OFF
		-DKDSoap_EXAMPLES=OFF # no install targets
		-DKDSoap_STATIC=OFF
		-DKDSoap_QT6=OFF
	)
	cmake_src_configure
}
