# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake java-pkg-2 optfeature xdg

HOMEPAGE="https://polymc.org/"
DESCRIPTION="A custom, open source Minecraft launcher"

if [[ ${PV} != 9999 ]]; then
	MY_PN="PolyMC"

	# Let's use the vendored tarball to avoid dealing with the submodules directly
	SRC_URI="
		https://github.com/PolyMC/PolyMC/releases/download/${PV}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz
	"
else
	inherit git-r3

	EGIT_REPO_URI="
		https://github.com/PolyMC/PolyMC
		https://github.com/MultiMC/libnbtplusplus
		https://github.com/stachenov/quazip
	"

	# Include all submodules
	EGIT_SUBMODULES=( '*' )
fi

# Apache-2.0 for MultiMC (PolyMC is forked from it)
# GPL-3 for PolyMC
# LGPL-3 for libnbtplusplus
# LGPL-2.1 with linking exception for Quazip
# See the rest of PolyMC's libraries at https://github.com/PolyMC/PolyMC/tree/develop/libraries
LICENSE="Apache-2.0 Boost-1.0 BSD BSD-2 GPL-2+ GPL-3 LGPL-3 LGPL-2.1-with-linking-exception OFL-1.1 MIT"

SLOT="0"
if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"

	# The PolyMC's files are unpacked to ${WORKDIR}/PolyMC-${PV}
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

IUSE="debug"

BDEPEND="
	>=virtual/jdk-1.8.0:*
	media-libs/libglvnd
"

QT_DEPS="
	>=dev-qt/qtcore-5.6.0:5
	>=dev-qt/qttest-5.6.0:5
	>=dev-qt/qtconcurrent-5.6.0:5
	>=dev-qt/qtgui-5.6.0:5
	>=dev-qt/qtnetwork-5.6.0:5
	>=dev-qt/qtwidgets-5.6.0:5
	>=dev-qt/qtxml-5.6.0:5
"

DEPEND="
	${QT_DEPS}
	>=virtual/jre-1.8.0:*
	virtual/opengl
	sys-libs/zlib
"

RDEPEND="${DEPEND}"

src_prepare() {
	cmake_src_prepare
}

src_configure(){
	if use debug; then
		CMAKE_BUILD_TYPE=Debug
	else
		# Prepare for LTO in 1.2.0 (?)
		# See https://github.com/PolyMC/PolyMC/pull/333
		CMAKE_BUILD_TYPE=Release
	fi

	local mycmakeargs=(
		# Do a system install
		-DLauncher_PORTABLE=0
		-DCMAKE_INSTALL_PREFIX="/usr"
		# Resulting binary is named polymc
		-DLauncher_APP_BINARY_NAME="${PN}"
	)

	cmake_src_configure
}

src_compile(){
	cmake_src_compile
}

pkg_postinst() {
	xdg_pkg_postinst

	# https://github.com/PolyMC/PolyMC/issues/227
	optfeature "old Minecraft (<= 1.12.2) support" x11-libs/libXrandr
}
