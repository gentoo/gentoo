# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/ghc-paths/ghc-paths-0.1.0.9.ebuild,v 1.8 2015/01/02 23:11:30 slyfox Exp $

EAPI=5

# haddock feature is explicitely disabled, as this library can be used as haddock depend
CABAL_FEATURES="lib profile"
inherit haskell-cabal

DESCRIPTION="Knowledge of GHC's installation directories"
HOMEPAGE="http://hackage.haskell.org/package/ghc-paths"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-lang/ghc-6.8.2:="
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.6"

src_prepare() {
	# ghc-patch it has awfully unportable (across cabal versions) ghc detection code
	# but in gentoo we install it to fixed patch, so remove Setup.hs detection code
	cabal-mksetup

	# and use gentoo's hardcoded one:
	# a few things we need to replace, and example values
	# GHC_PATHS_LIBDIR /usr/lib64/ghc-6.12.0.20091010
	# GHC_PATHS_DOCDIR /usr/share/doc/ghc-6.12.0.20091010/html
	# GHC_PATHS_GHC_PKG /usr/bin/ghc-pkg
	# GHC_PATHS_GHC /usr/bin/ghc (be careful: GHC_PATHS_GHC is a substring of GHC_PATHS_GHC_PKG)

	cat >"${S}/GHC/Paths.hs" <<-EOF
	module GHC.Paths ( ghc, ghc_pkg, libdir, docdir ) where

	libdir, docdir, ghc, ghc_pkg :: FilePath

	libdir  = "$(ghc-libdir)"
	docdir  = "/usr/share/doc/ghc-$(ghc-version)/html"

	ghc     = "$(ghc-getghc)"
	ghc_pkg = "$(ghc-getghcpkg)"
	EOF
}
