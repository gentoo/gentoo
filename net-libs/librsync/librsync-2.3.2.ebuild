# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Remote delta-compression library"
HOMEPAGE="https://librsync.github.io/"
SRC_URI="https://github.com/librsync/librsync/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/2.2"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

RDEPEND="dev-libs/popt"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DUSE_LIBB2=OFF
	)

	cmake_src_configure
}
