# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/haddock/haddock-2.10.0-r2.ebuild,v 1.10 2015/01/02 23:16:40 slyfox Exp $

EAPI="4"

CABAL_FEATURES="bin lib profile haddock hscolour nocabaldep"
inherit eutils haskell-cabal pax-utils

DESCRIPTION="A documentation-generation tool for Haskell libraries"
HOMEPAGE="http://www.haskell.org/haddock/"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
# ppc64 needs to be rekeyworded due to xhtml not being keyworded
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="dev-haskell/ghc-paths[profile?]
		=dev-haskell/xhtml-3000.2*[profile?]
		>=dev-lang/ghc-7.4 <dev-lang/ghc-7.6"
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.14"

RESTRICT="test" # avoid depends on QC

CABAL_EXTRA_BUILD_FLAGS="--ghc-options=-rtsopts"

src_prepare() {
	# we would like to avoid happy and alex depends
	epatch "${FILESDIR}"/${P}-drop-tools.patch
	# http://www.mail-archive.com/cvs-ghc@haskell.org/msg37186.html
	epatch "${FILESDIR}"/${P}-dont-crash-on-unicode-strings-in-doc-comments.patch
	# http://trac.haskell.org/haddock/ticket/202 fixed by upstream in ghc-7.4
	# branch only (fix is not in master branch on 20120626)
	epatch "${FILESDIR}/${P}-ticket-202.patch"

	for f in Lex Parse; do
		rm "src/Haddock/$f."*
		mv "dist/build/haddock/haddock-tmp/Haddock/$f.hs" src/Haddock/
	done
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
