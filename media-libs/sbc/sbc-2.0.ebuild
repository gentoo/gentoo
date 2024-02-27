# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

DESCRIPTION="Audio codec to connect bluetooth HQ audio devices as headphones or loudspeakers"
HOMEPAGE="https://git.kernel.org/?p=bluetooth/sbc.git"
SRC_URI="https://www.kernel.org/pub/linux/bluetooth/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
IUSE="static-libs"

# --enable-tester is building src/sbctester but the tarball is missing required
# .wav file to execute it
RESTRICT="test"

BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-1.5-ifdef-builtin.patch" )

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		$(use_enable static-libs static) \
		--disable-tester
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -delete || die
}
