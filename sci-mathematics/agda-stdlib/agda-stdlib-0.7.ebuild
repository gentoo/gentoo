# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/agda-stdlib/agda-stdlib-0.7.ebuild,v 1.1 2013/09/13 06:56:46 gienah Exp $

EAPI=5

CABAL_FEATURES="bin"
inherit haskell-cabal elisp-common

DESCRIPTION="Agda standard library"
HOMEPAGE="http://wiki.portal.chalmers.se/agda/"
SRC_URI="http://www.cse.chalmers.se/~nad/software/lib-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="profile"

DEPEND=">=sci-mathematics/agda-executable-2.3.0.1"
RDEPEND="=sci-mathematics/agda-2.3.2*[profile?]
		=dev-haskell/filemanip-0.3*[profile?]"

SITEFILE="50${PN}-gentoo.el"

S="${WORKDIR}/lib-${PV}"

src_prepare() {
	cabal-mksetup
}

src_compile() {
	haskell-cabal_src_compile
	"${S}"/dist/build/GenerateEverything/GenerateEverything \
		|| die "GenerateEverything failed"
	local prof
	use profile && prof="--ghc-flag=-prof"
	agda +RTS -K1G -RTS ${prof} \
		-i "${S}" -i "${S}"/src "${S}"/Everything.agda || die
	# Although my agda-9999 build has
	# /var/tmp/portage/sci-mathematics/agda-9999/work/agda-9999/dist/build/autogen/Paths_Agda.hs
	# containing:
	# datadir    = "/usr/share/agda-9999/ghc-7.6.1"
	# it fails without the --css option like:
	# /usr/share/agda-9999/ghc-7.4.1/Agda.css: copyFile: does not exist
	local cssdir=$(egrep 'datadir *=' "${S}/dist/build/autogen/Paths_lib.hs" | sed -e 's@datadir    = \(.*\)@\1@')
	agda --html -i "${S}" -i "${S}"/src --css="${cssdir}/Agda.css" "${S}"/README.agda || die
}

src_test() {
	agda -i "${S}" -i "${S}"/src README.agda || die
}

src_install() {
	insinto usr/share/agda-stdlib
	export INSOPTIONS=--preserve-timestamps
	doins -r src/*
	dodoc -r html/*
	elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
}
