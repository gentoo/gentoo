# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake qmake-utils

DESCRIPTION="Framework for creating Qt State Machine metacode using graphical user interfaces"
HOMEPAGE="https://github.com/KDAB/KDStateMachineEditor"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/KDAB/KDStateMachineEditor.git"
else
	SRC_URI="https://github.com/KDAB/KDStateMachineEditor/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="doc test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5[widgets]
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}
	test? (
		dev-qt/qttest:5
		dev-qt/qtxmlpatterns:5
	)
"
BDEPEND="
	media-gfx/graphviz
	doc? (
		app-doc/doxygen
		dev-qt/qthelp:5
	)
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=OFF
		-DWITH_INTERNAL_GRAPHVIZ=OFF
		-DBUILD_DOCS=$(usex doc)
		-DBUILD_TESTING=$(usex test)
		-DECM_MKSPECS_INSTALL_DIR=$(qt5_get_mkspecsdir)/modules
	)
	cmake_src_configure
}
