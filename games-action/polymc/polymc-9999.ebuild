# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake java-pkg-2 optfeature xdg

HOMEPAGE="https://polymc.org/ https://github.com/PolyMC/PolyMC"
DESCRIPTION="A custom, open source Minecraft launcher"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3

	EGIT_REPO_URI="
		https://github.com/PolyMC/PolyMC
		https://github.com/PolyMC/libnbtplusplus
	"

	EGIT_SUBMODULES=( 'depends/libnbtplusplus' )
else
	MY_PN="PolyMC"

	# Let's use the vendored tarball to avoid dealing with the submodules directly
	SRC_URI="
		https://github.com/PolyMC/PolyMC/releases/download/${PV}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz
	"

	# The PolyMC's files are unpacked to ${WORKDIR}/PolyMC-${PV}
	S="${WORKDIR}/${MY_PN}-${PV}"

	KEYWORDS="~amd64"
fi

# Apache-2.0 for MultiMC (PolyMC is forked from it)
# GPL-3 for PolyMC
# LGPL-3 for libnbtplusplus
# See the rest of PolyMC's libraries at https://github.com/PolyMC/PolyMC/tree/develop/libraries
LICENSE="Apache-2.0 Boost-1.0 BSD BSD-2 GPL-2+ GPL-3 LGPL-3 OFL-1.1 MIT"

SLOT="0"

IUSE="debug lto test"
REQUIRED_USE="
	lto? ( !debug )
"

RESTRICT="!test? ( test )"

MIN_QT="5.12.0"
QT_SLOT=5

QT_DEPS="
	>=dev-qt/qtconcurrent-${MIN_QT}:${QT_SLOT}
	>=dev-qt/qtcore-${MIN_QT}:${QT_SLOT}
	>=dev-qt/qtgui-${MIN_QT}:${QT_SLOT}
	>=dev-qt/qtnetwork-${MIN_QT}:${QT_SLOT}
	>=dev-qt/qttest-${MIN_QT}:${QT_SLOT}
	>=dev-qt/qtwidgets-${MIN_QT}:${QT_SLOT}
	>=dev-qt/qtxml-${MIN_QT}:${QT_SLOT}
"

# Required at both build-time and run-time
COMMON_DEPENDS="
	${QT_DEPS}
	>=dev-libs/quazip-1.3:=
	sys-libs/zlib
"

BDEPEND="
	app-text/scdoc
	kde-frameworks/extra-cmake-modules:5
"

DEPEND="
	${COMMON_DEPENDS}
	media-libs/libglvnd
	>=virtual/jdk-1.8.0:*
"

# At run-time we don't depend on JDK, only JRE
# And we need more than just the GL headers
RDEPEND="
	${COMMON_DEPENDS}
	>=virtual/jre-1.8.0:*
	virtual/opengl
"

src_prepare() {
	cmake_src_prepare

	# Prevent conflicting with the user's flags
	# See https://bugs.gentoo.org/848765 for more info
	sed -i -e 's/-Werror//' -e 's/-D_FORTIFY_SOURCE=2//' CMakeLists.txt || die 'Failed to remove -Werror and -D_FORTIFY_SOURCE via sed'
}

src_configure(){
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="/usr"
		# Resulting binary is named polymc
		-DLauncher_APP_BINARY_NAME="${PN}"
		# Force Qt5 to avoid accidentaly building the Qt6 version and breaking things
		-DLauncher_QT_VERSION_MAJOR=${QT_SLOT}

		-DENABLE_LTO=$(usex lto)
		-DBUILD_TESTING=$(usex test)
	)

	if use debug; then
		CMAKE_BUILD_TYPE=Debug
	else
		CMAKE_BUILD_TYPE=Release
	fi

	cmake_src_configure
}

src_compile(){
	cmake_src_compile
}

pkg_postinst() {
	xdg_pkg_postinst

	# https://github.com/PolyMC/PolyMC/issues/227
	optfeature "old Minecraft (<= 1.12.2) support" x11-libs/libXrandr

	optfeature "built-in MangoHud support" games-util/mangohud
	optfeature "built-in Feral Gamemode support" games-util/gamemode
}
