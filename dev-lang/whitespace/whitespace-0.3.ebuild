# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CABAL_FEATURES="bin"

inherit haskell-cabal

DESCRIPTION="Whitespace language interpreter in haskell"
HOMEPAGE="http://compsoc.dur.ac.uk/whitespace/"
SRC_URI="http://compsoc.dur.ac.uk/whitespace/downloads/wspace-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND="dev-lang/ghc"
RDEPEND=""

S="${WORKDIR}/WSpace"

src_prepare() {
	epatch -p1 "${FILESDIR}/${PN}-cabal.patch"
}

src_install() {
	cabal_src_install

	dohtml docs/tutorial.html
	use examples && dodoc -r examples
}
