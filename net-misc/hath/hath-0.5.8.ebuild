# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CABAL_FEATURES="test-suite"
inherit haskell-cabal

DESCRIPTION="Manipulate network blocks in CIDR notation"
HOMEPAGE="https://michael.orlitzky.com/code/hath.xhtml"
SRC_URI="https://michael.orlitzky.com/code/releases/${P}.tar.gz"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND=">=dev-haskell/cmdargs-0.10:=
	>=dev-haskell/split-0.2:=
	>=dev-haskell/tasty-0.8:=
	>=dev-haskell/tasty-hunit-0.8:=
	>=dev-haskell/tasty-quickcheck-0.8.1:=
	>=dev-lang/ghc-9.0.0:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-3.0.0.0
	test? (
		dev-util/shelltestrunner
		sys-apps/grep[pcre]
	)
"

src_install() {
	cabal_src_install
	doman "${S}/doc/man1/${PN}.1"
}
