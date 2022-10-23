# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used by GnuTLS"
HOMEPAGE="https://www.gnutls.org/download.html"
SRC_URI="https://gnutls.org/gnutls-release-keyring.gpg -> ${P}-release-keyring.gpg"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

src_install() {
	local files=( ${A} )
	insinto /usr/share/openpgp-keys
	newins - gnutls.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
