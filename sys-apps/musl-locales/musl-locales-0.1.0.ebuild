# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Locale program for musl libc"
HOMEPAGE="https://git.adelielinux.org/adelie/musl-locales"
SRC_URI="https://git.adelielinux.org/adelie/musl-locales/uploads/7e855b894b18ca4bf4ecb11b5bcbc4c1/${P}.tar.xz"

LICENSE="LGPL-3 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="!sys-libs/glibc"

src_configure() {
	local mycmakeargs=(
		-DLOCALE_PROFILE=OFF
	)
	cmake_src_configure
}
