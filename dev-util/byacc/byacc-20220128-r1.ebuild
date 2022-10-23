# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/thomasdickey.asc
inherit verify-sig

DESCRIPTION="The best variant of the Yacc parser generator"
HOMEPAGE="https://invisible-island.net/byacc/byacc.html"
SRC_URI="https://invisible-island.net/archives/${PN}/${P}.tgz"
SRC_URI+=" verify-sig? ( https://invisible-island.net/archives/${PN}/${P}.tgz.asc )"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-thomasdickey )"

DOCS=( ACKNOWLEDGEMENTS AUTHORS CHANGES NEW_FEATURES NOTES README )

src_configure() {
	econf --program-prefix=b
}
