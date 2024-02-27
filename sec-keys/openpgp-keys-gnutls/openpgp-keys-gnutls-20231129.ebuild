# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used by GnuTLS"
HOMEPAGE="https://www.gnutls.org/download.html"
SRC_URI="
	https://gnutls.org/gnutls-release-keyring.gpg -> ${P}-release-keyring.gpg
	https://keys.openpgp.org/vks/v1/by-fingerprint/462225C3B46F34879FC8496CD605848ED7E69871 -> ${P}-daiki-updated.gpg
"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_compile() {
	local files=( ${A} )
	local -x GNUPGHOME=${T}/.gnupg

	mkdir "${GNUPGHOME}" || die
	gpg --import "${files[@]/#/${DISTDIR}/}" || die "Key import failed"
	gpg --export --armor --export-options export-minimal > gnutls.asc || die
}

src_install() {
	insinto /usr/share/openpgp-keys
	doins gnutls.asc
}
