# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/readline/readline-1.0.1.0.ebuild,v 1.3 2012/09/15 07:48:35 gienah Exp $

EAPI=4

CABAL_FEATURES="haddock lib profile"
inherit base haskell-cabal

DESCRIPTION="An interface to the GNU readline library"
HOMEPAGE="http://hackage.haskell.org/package/readline"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND=">=dev-lang/ghc-6.4"
DEPEND="${RDEPEND}"

CABAL_CORE_LIB_GHC_PV="6.8.1 6.8.2 6.8.3 6.10.1 6.10.2"

PATCHES=("${FILESDIR}/${PN}-1.0.1.0-ghc-7.6.patch")
