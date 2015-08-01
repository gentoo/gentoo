# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/lhs2tex/lhs2tex-1.19.ebuild,v 1.1 2015/08/01 16:20:18 slyfox Exp $

EAPI=5

CABAL_FEATURES="bin"
inherit base haskell-cabal

DESCRIPTION="Preprocessor for typesetting Haskell sources with LaTeX"
HOMEPAGE="http://www.andres-loeh.de/lhs2tex/"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# dev-texlive/texlive-mathextra contains 'stmaryrd' font used
# for guide generation
RDEPEND=">=dev-tex/polytable-0.8.2
	dev-texlive/texlive-mathextra"

DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.10
		dev-haskell/mtl
		dev-haskell/regex-compat
		>=dev-lang/ghc-6.12.1"

# Setup.hs uses 'Text.Regex' available in both 'r-c' and 'r-c-tdfa'
HCFLAGS+=" -ignore-package=regex-compat-tdfa"

# datadir is /usr/share/${PN}/${GHC_VER} so mandir is ${DATADIR}/../../man
PATCHES=("${FILESDIR}/${PN}-1.18.1-mandir.patch")
