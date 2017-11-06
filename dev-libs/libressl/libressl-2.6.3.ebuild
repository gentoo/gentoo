# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

DESCRIPTION="Free version of the SSL/TLS protocol forked from OpenSSL"
HOMEPAGE="https://www.libressl.org"
SRC_URI="https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/${P}.tar.gz"

LICENSE="ISC openssl"
# Reflects ABI of libcrypto.so and libssl.so.  Since these can differ,
# we'll try to use the max of either.  However, if either change between
# versions, we have to change the subslot to trigger rebuild of consumers.
SLOT="0/44"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~x86"
IUSE="+asm nc static-libs"

RDEPEND="
	!dev-libs/openssl:0
	nc? ( !net-analyzer/openbsd-netcat )"
DEPEND="${RDEPEND}"
PDEPEND="app-misc/ca-certificates"

src_prepare() {
	# Correct hardcoded paths to use ca-certificates instead of cert.pem
	find "${S}"/{apps,crypto,tls} -type f -exec \
		sed -e 's|/cert.pem|/certs/ca-certificates.crt|' -i {} \; || die

	eapply_user
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_ASM=$(usex asm)
		-DENABLE_NC=$(usex nc)
		-DOPENSSLDIR="${EPREFIX}"/etc/ssl
		-DUSE_SHARED=1
	)

	cmake-multilib_src_configure
}

multilib_src_install_all() {
	einstalldocs

	# Delete cert.pem
	rm "${ED}"/etc/ssl/cert.pem || die

	if ! use static-libs ; then
		find "${D}" -name '*.a' -exec rm -f {} + || die
	fi
}
