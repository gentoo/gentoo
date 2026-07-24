# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

OSSL_FINGERPRINTS=(
	# OpenSSL <openssl@openssl.org>
	# See https://openssl-library.org/source/
	B146647E45A7B33947AB226B2A2C87D161692D40:openssl:manual

	# OpenSSL <openssl@openssl.org>
	# See https://openssl-library.org/source/
	BA5473A2B0587B07FB27CF2D216094DFD0CB81EF:opensslold:manual,openpgp
)

# We keep older keys here for now to allow verifying older & newer
# releases with the same keyring package. We'll drop them eventually.
#
# https://github.com/openssl/openssl/issues/19566
# https://github.com/openssl/openssl/issues/19567
OSSL_OLD_FINGERPRINTS=(
	# Matt Caswell <matt@openssl.org>
	5B2545DAB21995F4088CEFAA36CEE4DEB00CFE33:matt:ubuntu

	# Paul Dale <pauli@openssl.org>
	8657ABB260F056B1E5190839D9C4D26D0E604491:pauli:openpgp

	# Tim Hudson <tjh@openssl.org>
	B7C1C14360F353A36862E4D5231C84CDDCC69C45:tjh:openpgp

	# Hugo Landau <hlandau@openssl.org>
	95A9908DDFA16830BE9FB9003D30A3A9FF1360DC:hlandau:openpgp

	# Tomas Mraz <tomas@openssl.org>
	A21FAB74B0088AA361152586B8EF1A6BA9DA2D5C:tomas:openpgp

	# Kurt Roeckx <kurt@openssl.org>
	E5E52560DD91C556DDBDA5D02064C53641C25E5D:kurt:openpgp

	# OpenSSL OMC (see https://github.com/openssl/openssl/commit/f925bfebbb287321133b9251e72bee869a0f58b4)
	EFC0A467D613CB83C7ED6D30D894E2CE8B3D79F5:omc:manual
)

SEC_KEYS_VALIDPGPKEYS=(
	"${OSSL_FINGERPRINTS[@]}"
	"${OSSL_OLD_FINGERPRINTS[@]}"
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by OpenSSL"
HOMEPAGE="https://www.openssl.org/"
SRC_URI+=" https://openssl-library.org/source/pubkeys.asc -> ${P}-pubkeys.asc"
ossl_key=
for ossl_key in "${OSSL_OLD_FINGERPRINTS[@]}" ; do
	SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/openssl-keys-20240424-${ossl_key%%:*}.asc"
done
unset ossl_key

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

src_install() {
	sec-keys_src_install

	dosym openssl.asc /usr/share/openpgp-keys/openssl.org.asc
}
