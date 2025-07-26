# Copyright 2023-2025 Gentoo Authors
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

src_install() {
	cmake_src_install
	echo "MUSL_LOCPATH=\"/usr/share/i18n/locales/musl\"" | newenvd - 00locale
}

pkg_postinst() {
	elog "Run . /etc/profile and then eselect locale list"
	elog "to see available locales to use with musl. "
}
