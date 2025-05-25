# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="KDAB's Dock Widget Framework for Qt"
HOMEPAGE="https://www.kdab.com/development-resources/qt-tools/kddockwidgets/"
SRC_URI="https://github.com/KDAB/KDDockWidgets/releases/download/v${PV}/${P}.tar.gz"
S=${WORKDIR}/KDDockWidgets-${PV}

LICENSE="|| ( GPL-2 GPL-3 ) BSD MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="qml"
# building tests require developer mode which is messy to enable here
RESTRICT="test"

RDEPEND="
	dev-qt/qtbase:6[widgets]
	qml? ( dev-qt/qtdeclarative:6 )
"
DEPEND="
	${DEPEND}
	dev-cpp/nlohmann_json
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.1-include-paths.patch
)

src_configure() {
	local mycmakeargs=(
		-DKDDockWidgets_FRONTENDS=qtwidgets$(usev qml ';qtquick')
		-DKDDockWidgets_NO_SPDLOG=yes # less headaches
		-DKDDockWidgets_PYTHON_BINDINGS=no # ask if need this
		-DKDDockWidgets_QT6=yes
		-DKDDockWidgets_XLib=no # off by default, and fails to build
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	rm -r -- "${ED}"/usr/share/doc/${P}-qt6 || die
}
