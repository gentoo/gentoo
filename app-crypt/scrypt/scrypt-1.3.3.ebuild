# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/tarsnap.asc
inherit verify-sig

DESCRIPTION="A simple password-based encryption utility using scrypt key derivation function"
HOMEPAGE="https://www.tarsnap.com/scrypt.html"
SRC_URI="
	https://www.tarsnap.com/scrypt/${P}.tgz
	verify-sig? ( https://www.tarsnap.com/scrypt/${PN}-sigs-${PV}.asc )
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"

DOCS=( FORMAT )

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-tarsnap )"

src_unpack() {
	if use verify-sig; then
		cd "${DISTDIR}" || die
		verify-sig_verify_signed_checksums \
			${PN}-sigs-${PV}.asc \
			openssl-dgst \
			${P}.tgz
		cd "${WORKDIR}" || die
	fi

	default
}

src_test() {
	# There's an empty check target, so can't call default.
	emake test
}
