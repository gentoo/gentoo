# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/agda-stdlib/agda-stdlib-0.8.ebuild,v 1.1 2014/07/02 15:24:38 gienah Exp $

EAPI=5

CABAL_FEATURES="bin"
inherit haskell-cabal elisp-common

DESCRIPTION="Agda standard library"
HOMEPAGE="http://wiki.portal.chalmers.se/agda/"
SRC_URI="https://github.com/agda/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="profile +ffi"

# filemanip is used in lib.cabal to make the GenerateEverything and
# AllNonAsciiChars executables, so agda-stdlib does not require a subslot
# dependency on filemanip.

RDEPEND=">=sci-mathematics/agda-2.4:=[profile?]
	=dev-haskell/filemanip-0.3*[profile?]
	>=sci-mathematics/agda-executable-2.3.0.1:=
	>=dev-lang/ghc-6.12.1
	ffi? ( =sci-mathematics/agda-lib-ffi-0.0.2 )
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8.0.2
"

SITEFILE="50${PN}-gentoo.el"

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
