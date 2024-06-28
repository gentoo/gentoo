# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999* ]]; then
	SRC_URI="https://github.com/KDAB/KDSoap/releases/download/${P}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm arm64 ~loong ~ppc64 ~riscv ~x86"
else
	EGIT_REPO_URI="https://github.com/KDAB/KDSoap.git"
	EGIT_SUBMODULES=( kdwsdl2cpp/libkode -autogen )
	inherit git-r3
fi
inherit cmake multibuild

DESCRIPTION="Qt-based client-side and server-side SOAP component"
HOMEPAGE="https://www.kdab.com/development-resources/qt-tools/kd-soap/"

LICENSE="GPL-3 AGPL-3"
SLOT="0/2"
IUSE="+qt5 qt6"
REQUIRED_USE="|| ( qt5 qt6 )"

RDEPEND="
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5
		dev-qt/qtxml:5
	)
	qt6? ( dev-qt/qtbase:6[network,xml] )"
DEPEND="${RDEPEND}
	dev-libs/boost
"

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt5) $(usev qt6) )
}

src_prepare() {
	cmake_src_prepare
	sed -e "/install.*INSTALL_DOC_DIR/d" -i CMakeLists.txt || die
}

src_configure() {
	my_src_configure() {
		local mycmakeargs=(
			-DKDSoap_DOCS=OFF
			-DKDSoap_EXAMPLES=OFF # no install targets
			-DKDSoap_STATIC=OFF
		)

		if [[ ${MULTIBUILD_VARIANT} == qt6 ]]; then
			mycmakeargs+=( -DKDSoap_QT6=ON )
		else
			mycmakeargs+=( -DKDSoap_QT6=OFF )
		fi
		cmake_src_configure
	}

	multibuild_foreach_variant my_src_configure
}

src_compile() {
	multibuild_foreach_variant cmake_src_compile
}

src_install() {
	multibuild_foreach_variant cmake_src_install
}
