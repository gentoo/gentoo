# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/thomasdickey.asc
inherit verify-sig

DESCRIPTION="Generate C function prototypes from C source code"
HOMEPAGE="https://invisible-island.net/cproto/"
SRC_URI="https://invisible-island.net/archives/${PN}/${P}.tgz"
SRC_URI+=" verify-sig? ( https://invisible-island.net/archives/${PN}/${P}.tgz.asc )"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

DEPEND="
	sys-devel/flex
	virtual/yacc
"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-thomasdickey )"
