# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils kde5-functions multilib

QT_MINIMAL="5.3"

DESCRIPTION="Framework for creating Qt State Machine metacode using graphical user interfaces"
HOMEPAGE="https://github.com/KDAB/KDStateMachineEditor/ \
	https://github.com/KDAB/KDStateMachineEditor/wiki/"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/KDAB/KDStateMachineEditor.git"
else
	SRC_URI="https://github.com/KDAB/KDStateMachineEditor/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~x86 ~amd64"
	if [[ ${PV} == 1.2.1 ]] ; then
		PATCHES=( "${FILESDIR}/fix_hardcoded_installation_dirs-1.2.1.patch" )
	fi
fi

LICENSE="GPL-2+"
IUSE="doc doxygen examples +system-graphviz testing"
SLOT="0"

RDEPEND="
	$(add_qt_dep qtcore)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)
"

DEPEND="${RDEPEND}
	doc?			( $(add_qt_dep qthelp) )
	doxygen?		( app-doc/doxygen )
	system-graphviz?	( media-gfx/graphviz )
	testing?		( $(add_qt_dep qttest) )
"

REQUIRED_USE="doxygen? ( doc )"

src_configure() {
	local mycmakeargs+=(
		-DCMAKE_INSTALL_PREFIX=/usr
		-DBUILD_DOCS=$(usex doc)
		-DBUILD_EXAMPLES=$(usex examples)
		-DBUILD_TESTING=$(usex testing)
		-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=$(usex !doxygen)
		-DCMAKE_DISABLE_FIND_PACKAGE_Graphviz=$(usex !system-graphviz)
	)
	cmake-utils_src_configure
}
