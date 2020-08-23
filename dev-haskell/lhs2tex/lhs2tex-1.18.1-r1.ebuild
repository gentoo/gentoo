# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CABAL_FEATURES="bin"
inherit base haskell-cabal

DESCRIPTION="Preprocessor for typesetting Haskell sources with LaTeX"
HOMEPAGE="http://www.andres-loeh.de/lhs2tex/"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# dev-texlive/texlive-mathscience contains 'stmaryrd' font used
# for guide generation
# dev-texlive/texlive-latexextra for polytable
RDEPEND="dev-texlive/texlive-latexextra
	dev-texlive/texlive-mathscience"

DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.10
		dev-haskell/mtl
		dev-haskell/regex-compat
		>=dev-lang/ghc-6.12.1"

# Setup.hs uses 'Text.Regex' available in both 'r-c' and 'r-c-tdfa'
HCFLAGS+=" -ignore-package=regex-compat-tdfa"

# datadir is /usr/share/${PN}/${GHC_VER} so mandir is ${DATADIR}/../../man
PATCHES=("${FILESDIR}/${PN}-1.18.1-mandir.patch")
