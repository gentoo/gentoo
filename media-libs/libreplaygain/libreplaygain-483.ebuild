# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# svn export http://svn.musepack.net/libreplaygain@${PV} libreplaygain-${PV}
# tar -cJf libreplaygain-${PV}.tar.xz libreplaygain-${PV}

DESCRIPTION="Replay Gain library from Musepack"
HOMEPAGE="https://www.musepack.net/"
SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"

PATCHES=( "${FILESDIR}"/${P}-static-libs.patch )

src_prepare() {
	cmake_src_prepare

	sed -i -e '/CMAKE_C_FLAGS/d' CMakeLists.txt || die
}
