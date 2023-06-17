# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CABAL_FEATURES="test-suite"
inherit haskell-cabal

DESCRIPTION="Confirm delegation of NS and MX records"
HOMEPAGE="http://michael.orlitzky.com/code/haeredes.xhtml"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

# The test suite requires network access.
RESTRICT="test"

RDEPEND=">=dev-haskell/cmdargs-0.10:=
	>=dev-haskell/dns-1.4:=
	>=dev-haskell/iproute-1.2:=
	>=dev-haskell/parallel-io-0.3:=
	>=dev-lang/ghc-9.0.0:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-3.0.0
	test? ( >=dev-haskell/doctest-0.9
		>=dev-haskell/filemanip-0.3.6
		dev-util/shelltestrunner )
"

src_install() {
	haskell-cabal_src_install
	doman "${S}/doc/man1/${PN}.1"
}
