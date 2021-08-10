# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CABAL_FEATURES="test-suite"
inherit haskell-cabal

DESCRIPTION="Count mailboxes in a SQL database"
HOMEPAGE="https://hackage.haskell.org/package/mailbox-count"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-haskell/cmdargs-0.10
	>=dev-haskell/configurator-0.2
	>=dev-haskell/hdbc-2.4
	>=dev-haskell/hdbc-postgresql-2.3
	>=dev-haskell/hdbc-sqlite3-2.3
	>=dev-haskell/missingh-1.2
	>=dev-haskell/tasty-0.8
	>=dev-haskell/tasty-hunit-0.8
	>=dev-lang/ghc-8.0
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.16.0
	test? ( >=dev-haskell/doctest-0.9
		>=dev-haskell/filemanip-0.3.6 )"

src_install() {
	haskell-cabal_src_install
	dodoc "${S}/doc/${PN}rc.example"
	doman "${S}/doc/man1/${PN}.1"
}
