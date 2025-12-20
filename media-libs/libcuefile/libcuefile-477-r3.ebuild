# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# svn export http://svn.musepack.net/libcuefile/trunk libcuefile-${PV}
# tar -cJf libcuefile-${PV}.tar.xz libcuefile-${PV}

DESCRIPTION="Cue File library from Musepack"
HOMEPAGE="https://www.musepack.net/"
SRC_URI="https://dev.gentoo.org/~ssuominen/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"

PATCHES=(
	"${FILESDIR}"/${PN}-static-libs.patch
	"${FILESDIR}"/${PN}-477-clang16.patch
)

src_install() {
	cmake_src_install

	insinto /usr/include
	doins -r include/cuetools
}
