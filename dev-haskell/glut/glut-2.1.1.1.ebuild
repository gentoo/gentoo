# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/glut/glut-2.1.1.1.ebuild,v 1.7 2012/09/12 14:54:06 qnikst Exp $

CABAL_FEATURES="lib profile haddock"
CABAL_MIN_VERSION=1.2
inherit haskell-cabal

MY_PN="GLUT"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="GLUT bindings for haskell"
HOMEPAGE="http://www.haskell.org/HOpenGL/"
SRC_URI="mirror://hackage/packages/archive/${MY_PN}/${PV}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=dev-lang/ghc-6.4
	>=dev-haskell/opengl-2.2.1
	virtual/opengl
	media-libs/freeglut"

S="${WORKDIR}/${MY_P}"

# TODO: Install examples when the "examples" USE flag is set
