# Copyright 2022-2023 Gentoo Authors
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
KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~ppc ppc64 ~riscv ~s390 ~sparc ~x86"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-thomasdickey )"

src_configure() {
	econf --with-manpage-format=formatted
}
