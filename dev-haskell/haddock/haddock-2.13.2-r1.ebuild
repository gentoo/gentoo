# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/haddock/haddock-2.13.2-r1.ebuild,v 1.6 2015/08/01 21:42:46 slyfox Exp $

EAPI=5

CABAL_FEATURES="bin lib profile haddock hscolour nocabaldep"
inherit eutils haskell-cabal pax-utils

DESCRIPTION="A documentation-generation tool for Haskell libraries"
HOMEPAGE="http://www.haskell.org/haddock/"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz
		http://dev.gentoo.org/~qnikst/patches/dev-haskell-${PN}/${P}-pregenerated-files.patch
		"

LICENSE="BSD"
SLOT="0/${PV}"
# ia64 lost as we don't have ghc-7 there yet
# ppc64 needs to be rekeyworded due to xhtml not being keyworded
# x86-fbsd is lost due xhtml
KEYWORDS="amd64 -ia64 x86"
IUSE=""

RDEPEND="dev-haskell/ghc-paths:=[profile?]
		=dev-haskell/xhtml-3000.2*:=[profile?]
		>=dev-lang/ghc-7.6:= <dev-lang/ghc-7.7:="
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.14"

RESTRICT="test" # avoid depends on QC

CABAL_EXTRA_BUILD_FLAGS+=" --ghc-options=-rtsopts"

src_prepare() {
	# we would like to avoid happy and alex depends
	epatch "${DISTDIR}"/${P}-pregenerated-files.patch
	epatch "${FILESDIR}"/${PN}-2.13.1-drop-tools.patch
	# Fix: Ticket #213 Haddock fails when advanced typesystem features are used
	# epatch "${FILESDIR}"/${PN}-2.13.1-renameType.patch
	if use doc && [ ! -e "${S}/html" ]; then
		ln -s "${S}/resources/html" "${S}/html" || die "Could not create symbolic link ${S}/html"
	fi
}

src_configure() {
	# create a fake haddock executable. it'll set the right version to cabal
	# configure, but will eventually get overwritten in src_compile by
	# the real executable.
	local exe="${S}/dist/build/haddock/haddock"
	mkdir -p $(dirname "${exe}")
	echo -e "#!/bin/sh\necho Haddock version ${PV}" > "${exe}"
	chmod +x "${exe}"

	# we use 'nocabaldep' to use ghc's bundled Cabal
	# as external one is likely to break our haddock
	# (known to work on 1.16.0 and breaks on 1.16.0.1!)
	haskell-cabal_src_configure \
		--with-haddock="${exe}" \
		--constraint="Cabal == $(cabal-version)"
}

src_compile() {
	# when building the (recursive..) haddock docs, change the datadir to the
	# current directory, as we're using haddock inplace even if it's built to be
	# installed into the system first.
	haddock_datadir="${S}" haskell-cabal_src_compile
}

src_install() {
	cabal_src_install
	# haddock uses GHC-api to process TH source.
	# TH requires GHCi which needs mmap('rwx') (bug #299709)
	pax-mark -m "${D}/usr/bin/${PN}"
}
