# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/opengl/opengl-2.2.1.1.ebuild,v 1.7 2012/09/12 15:52:30 qnikst Exp $

CABAL_FEATURES="lib profile haddock"
inherit base haskell-cabal

MY_PN=OpenGL
MY_P="${MY_PN}-${PV}"

DESCRIPTION="OpenGL bindings for haskell"
HOMEPAGE="http://haskell.org/ghc/"
SRC_URI="mirror://hackage/packages/archive/${MY_PN}/${PV}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 sparc x86"
IUSE=""

DEPEND=">=dev-lang/ghc-6.4
	virtual/opengl
	virtual/glu
	media-libs/freeglut"

S="${WORKDIR}/${MY_P}"

PATCHES=("${FILESDIR}/${P}-ghc-7.4.patch")
