# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Built with autotools rather than cmake to avoid circular dep (bug #951524

inherit multilib-minimal

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ngtcp2/ngtcp2.git"
	inherit autotools git-r3
else
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/ngtcp2.asc
	inherit verify-sig
	SRC_URI="
		https://github.com/ngtcp2/ngtcp2/releases/download/v${PV}/${P}.tar.xz
		verify-sig? ( https://github.com/ngtcp2/ngtcp2/releases/download/v${PV}/${P}.tar.xz.asc )
	"

	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
	BDEPEND="verify-sig? ( sec-keys/openpgp-keys-ngtcp2 )"
fi

DESCRIPTION="Implementation of the IETF QUIC Protocol"
HOMEPAGE="https://nghttp2.org/ngtcp2/ https://github.com/ngtcp2/ngtcp2"

LICENSE="MIT"
SLOT="0/0"
IUSE="gnutls +openssl +ssl"
REQUIRED_USE="ssl? ( || ( gnutls openssl ) )"

# Uses SSL_set_quic_tls_cbs to detect OpenSSL. The function was introduced in
# OpenSSL 3.5:
# https://docs.openssl.org/master/man3/SSL_set_quic_tls_cbs/#history.
RDEPEND="
	ssl? (
		gnutls? ( >=net-libs/gnutls-3.7.2:=[${MULTILIB_USEDEP}] )
		openssl? ( >=dev-libs/openssl-3.5:=[${MULTILIB_USEDEP}] )
	)
"
DEPEND="${RDEPEND}"
BDEPEND+=" virtual/pkgconfig"

# QuicTLS function, the OpenSSL support is checked via SSL_set_quic_tls_cbs.
QA_CONFIG_IMPL_DECL_SKIP=(
	'SSL_provide_quic_data'
)

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
