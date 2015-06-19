# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/deepseq/deepseq-1.3.0.1.ebuild,v 1.11 2014/12/20 09:39:01 slyfox Exp $

EAPI=5

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

MY_P="${P/_pre*/}"

DESCRIPTION="Deep evaluation of data structures"
HOMEPAGE="http://hackage.haskell.org/package/deepseq"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND=">=dev-lang/ghc-6.10.4:="
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.6"

S="${WORKDIR}/${MY_P}"

CABAL_CORE_LIB_GHC_PV="7.6.* 7.7.20121101 7.7.20121213"

src_prepare() {
	cabal_chdeps \
		'array      >= 0.1 && < 0.5' 'array      >= 0.1'
}
