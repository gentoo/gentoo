# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CABAL_FEATURES="test-suite"
inherit haskell-cabal

DESCRIPTION="Basic syntax and deliverability checks on email addresses"
HOMEPAGE="https://michael.orlitzky.com/code/email-validator.xhtml"
SRC_URI="https://michael.orlitzky.com/code/releases/${P}.tar.gz"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT=test # Ambiguous module name 'Network.DNS': dns-4.0.1 resolv-0.1.2.0

RDEPEND=">=dev-haskell/cmdargs-0.10:=
	>=dev-haskell/dns-2:=
	>=dev-haskell/email-validate-2:=
	>=dev-haskell/hunit-1.2:=
	>=dev-haskell/parallel-io-0.3:=
	>=dev-haskell/pcre-light-0.4:=
	>=dev-haskell/tasty-0.8:=
	>=dev-haskell/tasty-hunit-0.8:=
	>=dev-lang/ghc-7.6.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.16.0
	test? ( >=dev-haskell/doctest-0.9 )
"

src_install() {
	haskell-cabal_src_install
	doman "${S}/doc/man1/${PN}.1"
}
