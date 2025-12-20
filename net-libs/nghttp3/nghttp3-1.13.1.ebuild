# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Built with autotools rather than cmake to avoid circular dep (bug #951524)

inherit multilib-minimal

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ngtcp2/nghttp3.git"
	inherit autotools git-r3
else
	SRC_URI="https://github.com/ngtcp2/nghttp3/releases/download/v${PV}/${P}.tar.xz"
	inherit libtool

	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
fi

DESCRIPTION="HTTP/3 library written in C"
HOMEPAGE="https://github.com/ngtcp2/nghttp3"

LICENSE="MIT"
SLOT="0/0"

src_prepare() {
	default
	if [[ ${PV} == 9999 ]]; then
		eautoreconf
	else
		elibtoolize
	fi
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-werror
		--disable-debug
		--enable-lib-only
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}"/usr -type f -name '*.la' -delete || die
}
