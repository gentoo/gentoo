# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="ZNC module which provides client specific buffers"
HOMEPAGE="https://github.com/CyberShadow/znc-clientbuffer"
SRC_URI="https://github.com/CyberShadow/znc-clientbuffer/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

DEPEND="net-irc/znc:="
RDEPEND="${DEPEND}"
BDEPEND=">=dev-build/cmake-3.31"

src_prepare() {
	cp -v "${FILESDIR}/CMakeLists.txt" . || die
	cmake_src_prepare
}
