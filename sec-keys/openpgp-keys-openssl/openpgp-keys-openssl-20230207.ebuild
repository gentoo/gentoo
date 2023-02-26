# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by OpenSSL"
HOMEPAGE="https://www.openssl.net/"

# See the following:
# - https://www.openssl.org/source/
# - https://www.openssl.org/community/otc.html
# - https://www.openssl.org/community/omc.html
# Mirrored from https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x8657ABB260F056B1E5190839D9C4D26D0E604491 etc (unstable results)
# ```
# mkdir /tmp/tmp-gpg
# gpg --no-default-keyring --homedir=/tmp/tmp-gpg --keyserver keyserver.ubuntu.com --recv-keys "${OSSL_FINGERPRINTS[@]}" || exit 1
#
# for key in "${OSSL_FINGERPRINTS[@]}" ; do
#  gpg --no-default-keyring --homedir=/tmp/tmp-gpg --export "${key}" > openssl-keys-20221101-${key}.asc
# done
# ```
#
# https://github.com/openssl/openssl/issues/19566
# https://github.com/openssl/openssl/issues/19567

OSSL_FINGERPRINTS=(
	# Matt Caswell <matt@openssl.org>
	5B2545DAB21995F4088CEFAA36CEE4DEB00CFE33

	# Paul Dale <pauli@openssl.org>
	8657ABB260F056B1E5190839D9C4D26D0E604491

	# Tim Hudson <tjh@openssl.org>
	B7C1C14360F353A36862E4D5231C84CDDCC69C45

	# Hugo Landau <hlandau@openssl.org>
	95A9908DDFA16830BE9FB9003D30A3A9FF1360DC

	# Tomas Mraz <tomas@openssl.org>
	A21FAB74B0088AA361152586B8EF1A6BA9DA2D5C

	# Richard Levitte <levitte@openssl.org>
	7953AC1FBC3DC8B3B292393ED5E9E43F7DF9EE8C

	# Kurt Roeckx <kurt@openssl.org>
	E5E52560DD91C556DDBDA5D02064C53641C25E5D
)

ossl_key=
for ossl_key in "${OSSL_FINGERPRINTS[@]}" ; do
	SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/openssl-keys-${PV}-${ossl_key}.asc"
done
unset ossl_key

S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ~ppc64 ~riscv ~s390 ~sparc x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - openssl.org.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
