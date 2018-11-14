# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="The Haskell Platform"
HOMEPAGE="https://www.haskell.org/platform/"
SRC_URI=""

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="profile X"

RDEPEND=">=dev-haskell/async-2.0.1.3:=[profile?]
		>=dev-haskell/cgi-3001.1.7.4:=[profile?]
		>=dev-haskell/fgl-5.4.2.4:=[profile?]
		>=dev-haskell/haskell-src-1.0.1.5:=[profile?]
		>=dev-haskell/html-1.0.1.2:=[profile?]
		>=dev-haskell/http-4000.2.5:=[profile?]
		>=dev-haskell/hunit-1.2.5.1:=[profile?]
		>=dev-haskell/mtl-2.1.2:=[profile?]
		>=dev-haskell/network-2.3.1.0:=[profile?]
		>=dev-haskell/parallel-3.2.0.3:=[profile?]
		>=dev-haskell/parsec-3.1.3:=[profile?]
		>=dev-haskell/primitive-0.5.0.1:=[profile?]
		>=dev-haskell/quickcheck-2.5.1.1:=[profile?]
		>=dev-haskell/random-1.0.1.1:=[profile?]
		>=dev-haskell/regex-base-0.93.2:=[profile?]
		>=dev-haskell/regex-compat-0.95.1:=[profile?]
		>=dev-haskell/regex-posix-0.95.2:=[profile?]
		>=dev-haskell/split-0.2.1.1:=[profile?]
		>=dev-haskell/stm-2.4:=[profile?]
		>=dev-haskell/syb-0.3.7:=[profile?]
		>=dev-haskell/text-0.11.2.3:=[profile?]
		>=dev-haskell/transformers-0.3.0.0:=[profile?]
		>=dev-haskell/vector-0.10.0.1:=[profile?]
		>=dev-haskell/xhtml-3000.2.1:=[profile?]
		>=dev-haskell/zlib-0.5.4.0:=[profile?]
		X? (
			>=dev-haskell/glut-2.1.2.1:=[profile?]
			>=dev-haskell/opengl-2.2.3.1:=[profile?]
		)
		>=dev-lang/ghc-7.4.2:=

		>=dev-haskell/alex-3.0.2
		>=dev-haskell/cabal-1.14.0
		>=dev-haskell/happy-1.18.10
		>=dev-haskell/cabal-install-0.14.0
		>=dev-haskell/hscolour-1.19
		>=dev-haskell/haddock-2.10.0"

DEPEND="${RDEPEND}"

pkg_postinst() {
	if ! use X; then
		elog "The haskell platform includes the 3D graphics libraries opengl and glut."
		elog "To install opengl and glut requires the X use flag."
	fi
}
