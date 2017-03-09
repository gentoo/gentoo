# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eutils

DESCRIPTION="edb is a cross platform x86/x86-64 debugger, inspired by Ollydbg"
HOMEPAGE="https://github.com/eteran/edb-debugger"

LICENSE="GPL-2+"
IUSE="graphviz legacy-mem-write pax_kernel"
SLOT="0"

SRC_URI="https://github.com/eteran/edb-debugger/releases/download/${PV}/edb-debugger-${PV}.tgz"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/edb-debugger-${PV}"

RDEPEND="
	>=dev-libs/capstone-3.0
	graphviz? ( >=media-gfx/graphviz-2.38.0 )
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dev-qt/qtxmlpatterns:5
	dev-qt/qtnetwork:5
	dev-qt/qtconcurrent:5
	dev-qt/qtgui:5
	dev-qt/qtcore:5
	"
DEPEND="
	>=dev-libs/boost-1.35.0
	virtual/pkgconfig
	${RDEPEND}"

src_prepare(){
	#Remove this in a future version; There won't be any edb48-logo.png
	sed -i  '/edb48-logo/d' CMakeLists.txt || die

	#Make the desktop's entries somewhat cuter
	sed -i -e 's/GenericName=edb debugger/GenericName=Evan\x27s Debugger/' edb.desktop || die
	sed -i -e 's/Comment=edb debugger/Comment=edb is a cross platform x86\/x86-64 debugger/' edb.desktop || die

	if ! use graphviz; then
		sed -i '/pkg_check_modules(GRAPHVIZ/d' CMakeLists.txt || die
	fi
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/usr
		-DQT_VERSION=Qt5
	)
	if use pax_kernel || use legacy-mem-write; then
		mycmakeargs+=( -DASSUME_PROC_PID_MEM_WRITE_BROKEN=Yes )
	else
		mycmakeargs+=( -DASSUME_PROC_PID_MEM_WRITE_BROKEN=No )
	fi

	cmake-utils_src_configure
}

src_install() {
	cd src/images/ || die
	newicon "edb48-logo.png" "edb.png"
	cmake-utils_src_install
}

pkg_postinst() {
	if use legacy-mem-write; then
		ewarn "You really do not want to turn on legacy-mem-write unless you need it."
		ewarn "Be sure to test without legacy-mem-write first and only enable if you actually need it."
	else
		ewarn
		ewarn "If you notice that EDB doesn't work correctly, enable legacy-mem-write USE Flag"
		ewarn "Please Report Bugs & Requests At: https://github.com/eteran/edb-debugger/issues"
		ewarn
	fi
}
