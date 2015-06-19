# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/openal/openal-1.3.1.1.ebuild,v 1.6 2014/08/01 09:50:23 armin76 Exp $

CABAL_FEATURES="lib profile haddock"
inherit haskell-cabal

MY_PN="OpenAL"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A Haskell binding to the OpenAL cross-platform 3D audio API"
HOMEPAGE="http://haskell.org/ghc/"
SRC_URI="mirror://hackage/packages/archive/${MY_PN}/${PV}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS=" amd64 x86"
IUSE=""

DEPEND=">=dev-lang/ghc-6.4
	>=dev-haskell/opengl-2.2.1
	media-libs/openal"

S="${WORKDIR}/${MY_P}"

#TODO: install examples perhaps?
