# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/thomasdickey.asc
inherit verify-sig

DESCRIPTION="This is a variant of the flex fast lexical scanner"
HOMEPAGE="https://invisible-island.net/reflex/"
SRC_URI="https://invisible-island.net/archives/${PN}/${P}.tgz"
SRC_URI+=" verify-sig? ( https://invisible-island.net/archives/${PN}/${P}.tgz.asc )"

LICENSE="FLEX"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-thomasdickey )"

src_install() {
	default

	# Workaround assumption of gzip compressed manpage
	# Reported upstream via email
	rm "${ED}"/usr/share/man/man1/reflex++.1.gz || die
	dosym reflex.1 /usr/share/man/man1/reflex++.1 || die
}
