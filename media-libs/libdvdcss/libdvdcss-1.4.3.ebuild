# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="A portable abstraction library for DVD decryption"
HOMEPAGE="https://www.videolan.org/developers/libdvdcss.html"
SRC_URI="https://download.videolan.org/pub/${PN}/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="1.2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x86-solaris"
IUSE="doc"

BDEPEND="doc? ( app-doc/doxygen )"

multilib_src_configure() {
	ECONF_SOURCE=${S} econf \
		--disable-static \
		$(multilib_native_use_enable doc)
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}
