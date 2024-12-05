# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="BBS client based on Qt"
HOMEPAGE="https://github.com/qterm/qterm"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="ssh"

RDEPEND="
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[gui,network,widgets,X,xml]
	x11-libs/libX11
	ssh? ( dev-libs/openssl:= )
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	dev-qt/qttools:6[assistant,linguist]
"

DOCS=( README.rst RELEASE_NOTES TODO doc/script.txt )

PATCHES=(
	"${FILESDIR}/${P}-fix-case-fallthrough.patch"
	"${FILESDIR}/${P}-gcc14-fix-Wunused.patch"
	"${FILESDIR}/${P}-missing-QDebug-include.patch"
	"${FILESDIR}/${P}-fix-typo.patch"
)

src_prepare() {
	# no Qt5 automagic, please
	sed -e "/^ *find_package.*QT NAMES/s/Qt5 //" -i CMakeLists.txt || die

	cmake_run_in src cmake_comment_add_subdirectory scripts

	# file collision with sys-cluster/torque, bug #176533
	sed -i "/PROGRAME /s/qterm/QTerm/" CMakeLists.txt || die
	sed -i "s/Exec=qterm/Exec=QTerm/" src/${PN}.desktop || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		# not ported from Qt4
		-DQTERM_ENABLE_TEST=OFF
		# not ported from Qt5
		-DQTERM_ENABLE_SCRIPT=OFF
		-DQTERM_ENABLE_SCRIPT_DEBUGGER=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Script=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6ScriptTools=ON
		-DQTERM_ENABLE_QMEDIAPLAYER=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt6Multimedia=ON
		# not wired up at all
		-DQTERM_ENABLE_DBUS=OFF
		-DQTERM_ENABLE_PHONON=OFF
		-DQTERM_ENABLE_SSH=$(usex ssh)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# proper Wayland session application icon
	mv "${ED}"/usr/share/applications/{qterm,QTerm}.desktop || die
}
