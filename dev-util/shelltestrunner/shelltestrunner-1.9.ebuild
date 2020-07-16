# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CABAL_FEATURES="bin"
inherit haskell-cabal

DESCRIPTION="A tool for testing command-line programs"
HOMEPAGE="https://github.com/simonmichael/shelltestrunner"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-haskell/cmdargs-0.7:=
	>=dev-haskell/diff-0.2.0:=
	>=dev-haskell/filemanip-0.3:=
	dev-haskell/hunit:=
	dev-haskell/parsec:=
	>=dev-haskell/pretty-show-1.6.5:=
	>=dev-haskell/regex-tdfa-1.1:=
	dev-haskell/safe:=
	>=dev-haskell/test-framework-0.3.2:=
	>=dev-haskell/test-framework-hunit-0.2:=
	>=dev-haskell/utf8-string-0.3.5:=
	>=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.6

"

src_test() {
	# First we have to prepend "dist/build/shelltest" to the PATH, so
	# that when the tests themselves run "shelltest", they get the
	# recently-built executable and not an already-installed one. Then
	# we exclude the Windows tests, leaving (for now...) only the Unix
	# and generic ones.
	#
	# We also skip the macro tests for now because the sdist is missing
	# some files:
	#
	#   https://github.com/simonmichael/shelltestrunner/issues/13
	#
	LANGUAGE=en \
	PATH="dist/build/shelltest:${PATH}" \
		shelltest -x .windows -x macros.test tests/ || die 'test suite failed'
}
