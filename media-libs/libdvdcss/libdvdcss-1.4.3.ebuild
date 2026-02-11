# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit multilib-minimal

DESCRIPTION="A portable abstraction library for DVD decryption"
HOMEPAGE="https://www.videolan.org/developers/libdvdcss.html"
SRC_URI="https://download.videolan.org/pub/${PN}/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="1.2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86 ~arm64-macos ~x64-macos"
IUSE="doc"

BDEPEND="doc? ( app-text/doxygen )"

src_prepare() {
	default

	# bug 969100 -no-cpp-precomp works with gcc-apple and probably
	# AppleClang, neither of which we use on macOS systems in Gentoo Prefix
	sed -i -e 's/-no-cpp-precomp//' configure || die
}

multilib_src_configure() {
	ECONF_SOURCE=${S} econf \
		--disable-static \
		$(multilib_native_use_enable doc)
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}
