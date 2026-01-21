# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Built with autotools rather than cmake to avoid circular dep (bug #951524

inherit multilib-minimal

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ngtcp2/ngtcp2.git"
	inherit autotools git-r3
else
	SRC_URI="https://github.com/ngtcp2/ngtcp2/releases/download/v${PV}/${P}.tar.xz"

	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

DESCRIPTION="Implementation of the IETF QUIC Protocol"
HOMEPAGE="https://github.com/ngtcp2/ngtcp2"

LICENSE="MIT"
SLOT="0/0"
IUSE="+gnutls openssl +ssl"
REQUIRED_USE="ssl? ( || ( gnutls openssl ) )"

RDEPEND="
	ssl? (
		gnutls? ( >=net-libs/gnutls-3.7.2:=[${MULTILIB_USEDEP}] )
		openssl? ( >=dev-libs/openssl-1.1.1:=[${MULTILIB_USEDEP}] )
	)
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	[[ ${PV} == 9999 ]] && eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-werror
		--enable-lib-only
		$(use_with openssl)
		$(use_with gnutls)
		--without-boringssl
		--without-picotls
		--without-wolfssl
		--without-libev
		--without-libnghttp3
		--without-jemalloc
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}"/usr -type f -name '*.la' -delete || die
}
