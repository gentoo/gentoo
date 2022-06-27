# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit verify-sig

EGIT_COMMIT=cb113fe442f84ab7d4ac95b44c49812001e32350
MY_P=${P#signify-keys-}
DESCRIPTION="Signify keys used to sign signify portable releases"
HOMEPAGE="https://github.com/aperezdc/signify"
SRC_URI="
	https://github.com/aperezdc/signify/raw/${EGIT_COMMIT}/keys/signifyportable.pub
		-> ${MY_P}.pub
	verify-sig? (
		https://github.com/aperezdc/signify/raw/${EGIT_COMMIT}/keys/signifyportable.pub.asc
			-> ${MY_P}.pub.asc
	)"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="${PV}"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/signify.asc

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-signify )"

src_install() {
	insinto /usr/share/signify-keys
	doins "${DISTDIR}/${MY_P}.pub"
}
