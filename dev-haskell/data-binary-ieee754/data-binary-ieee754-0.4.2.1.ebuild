# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/data-binary-ieee754/data-binary-ieee754-0.4.2.1.ebuild,v 1.2 2012/09/12 15:55:49 qnikst Exp $

EAPI="3"

CABAL_FEATURES="bin lib profile haddock hscolour hoogle"
inherit haskell-cabal

DESCRIPTION="Parser/Serialiser for IEEE-754 floating-point values"
HOMEPAGE="http://john-millikin.com/software/data-binary-ieee754/"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="<dev-haskell/binary-0.6
		>=dev-lang/ghc-6.8.2"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.6"
