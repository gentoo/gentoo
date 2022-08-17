# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A ZNC module which provides client specific buffers"
HOMEPAGE="https://github.com/CyberShadow/znc-clientbuffer"
SRC_URI="https://github.com/CyberShadow/znc-clientbuffer/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	net-irc/znc:="

RDEPEND="${DEPEND}"

src_prepare() {
	cp -v "${FILESDIR}/CMakeLists.txt" "${S}" || die
	cmake_src_prepare
}

src_compile() {
	cmake_src_compile
}

src_install() {
	exeinto /usr/$(get_libdir)/znc
	doexe "${BUILD_DIR}"/clientbuffer.so

	einstalldocs
}
