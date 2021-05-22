# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used to sign crypto++ releases"
HOMEPAGE="https://cryptopp.com/signing.html"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"

src_install() {
	# Note: Currently Jeffrey Walton (noloader) makes releases, but may need to add
	# others in future (listed on HOMEPAGE)
	# (only one other fingerprint is given though and they haven't made a release in ages,
	# so avoiding adding that for now.)
	local files=(
		"${FILESDIR}"/${PN}-noloader.asc
	)

	insinto /usr/share/openpgp-keys
	newins - crypto++.asc < <(cat "${files[@]}" || die)
}
