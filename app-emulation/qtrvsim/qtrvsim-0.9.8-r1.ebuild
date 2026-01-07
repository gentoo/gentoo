# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="RISC-V CPU simulator for education"
HOMEPAGE="https://github.com/cvut/qtrvsim"
SRC_URI="
	https://github.com/cvut/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
	https://github.com/cvut/qtrvsim/commit/ce63bb060fa8adb2215547da8a12d4e8d5a8f87e.patch
		-> ${PN}-0.9.8-svgscene-fix-build-when-qt6-is-specified.patch
	https://github.com/Flowdalic/qtrvsim/commit/33c9fc538c950da2ebad2cd7bfee28d4a37fd586.patch
		-> ${PN}-0.9.8-fix-compilation-with-qt-6.10.patch
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64"

DEPEND="
	dev-qt/qtbase:6[gui,widgets]
	virtual/libelf:=
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${DISTDIR}"/${PN}-0.9.8-svgscene-fix-build-when-qt6-is-specified.patch
	"${DISTDIR}"/${PN}-0.9.8-fix-compilation-with-qt-6.10.patch
)

src_configure() {
	local mycmakeargs=(
		-DQT_VERSION_MAJOR=6
	)
	cmake_src_configure
}
