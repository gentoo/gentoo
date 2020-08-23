# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CABAL_FEATURES="bin"
inherit haskell-cabal elisp-common

## shared with sci-mathematics/agda
# upstream does not maintain version ordering:
#  https://github.com/agda/agda-stdlib/releases
# 0.11 -> 2.5.0.20160213 -> 2.5.0.20160412 -> 0.12 -> 0.13
# As Agda-stdlib is tied to Agda version we encode
# both versions in gentoo version.
##
MY_UPSTREAM_AGDA_STDLIB_V="0.13"
MY_GENTOO_AGDA_STDLIB_V="${PV}.${MY_UPSTREAM_AGDA_STDLIB_V}"
MY_UPSTREAM_AGDA_V="${PV%.${MY_UPSTREAM_AGDA_STDLIB_V}}"

DESCRIPTION="Agda standard library"
HOMEPAGE="https://wiki.portal.chalmers.se/agda/"
SRC_URI="https://github.com/agda/${PN}/archive/v${MY_UPSTREAM_AGDA_STDLIB_V}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="profile +ffi"

RDEPEND=">=sci-mathematics/agda-${MY_UPSTREAM_AGDA_V}:=[profile?]
	ffi? ( sci-mathematics/agda-lib-ffi )
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.16.0
	>=dev-haskell/filemanip-0.3.6.2[profile?] <dev-haskell/filemanip-0.4[profile?]
	>=dev-lang/ghc-7.6.3
"

S=${WORKDIR}/${PN}-${MY_UPSTREAM_AGDA_STDLIB_V}

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
	insopts --preserve-timestamps
	doins -r src/*
	dodoc -r html/*
	doins "${FILESDIR}/standard-library.agda-lib"
}
