# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

# svn export http://svn.musepack.net/libmpc/trunk musepack-tools-${PV}
# tar -cjf musepack-tools-${PV}.tar.bz2 musepack-tools-${PV}

DESCRIPTION="Musepack SV8 libraries and utilities"
HOMEPAGE="https://www.musepack.net"
SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}.tar.xz"

LICENSE="BSD LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

DEPEND="
	>=media-libs/libcuefile-477
	>=media-libs/libreplaygain-477
"
RDEPEND="
	${DEPEND}
"

PATCHES=(
	"${FILESDIR}"/${P}-respect-cflags.patch
	"${FILESDIR}"/${P}-fixup-link-depends.patch
	"${FILESDIR}"/${P}-incompatible-pointers.patch
)

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/860882
	#
	# Software is dead since 2016.
	filter-lto

	# Symbols are decorated with MPC_API but visibility isn't wired up to the
	# build system(s)
	append-flags -fvisibility=hidden

	cmake_src_configure
}
