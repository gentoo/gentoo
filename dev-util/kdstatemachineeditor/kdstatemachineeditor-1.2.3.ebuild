# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils kde5-functions

DESCRIPTION="Framework for creating Qt State Machine metacode using graphical user interfaces"
HOMEPAGE="https://github.com/KDAB/KDStateMachineEditor"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/KDAB/KDStateMachineEditor.git"
else
	SRC_URI="https://github.com/KDAB/KDStateMachineEditor/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2+"
IUSE="doc test"
SLOT="0"

RDEPEND="
	$(add_qt_dep qtcore)
	$(add_qt_dep qtdeclarative 'widgets')
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)
"

DEPEND="${RDEPEND}
	doc? (
		$(add_qt_dep qthelp)
		app-doc/doxygen
	)
	test? (
		$(add_qt_dep qttest)
		$(add_qt_dep qtxmlpatterns)
	)
	media-gfx/graphviz
"

PATCHES=( "${FILESDIR}"/${P}-qt-5.11.patch )

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=OFF
		-DBUILD_DOCS=$(usex doc)
		-DBUILD_TESTING=$(usex test)
	)
	cmake-utils_src_configure
}
