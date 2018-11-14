# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

inherit eutils multilib

DESCRIPTION="Cluster tools for fixing common allocation problems on Ganeti 2.0
clusters"
HOMEPAGE="http://www.ganeti.org/"
SRC_URI="https://ganeti.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc test"

DEPEND="dev-lang/ghc
	dev-haskell/json
	dev-haskell/curl
	dev-haskell/network
	dev-haskell/parallel"
RDEPEND="${DEPEND}
	!<app-emulation/ganeti-2.4"
DEPEND+=" test? ( dev-haskell/quickcheck:1 )"

src_prepare() {
	# htools does not currently compile cleanly with ghc-6.12+, so remove this
	# for now
	sed -i -e "s:-Werror ::" Makefile
	# Workaround to skip pandoc
	sed -i -e "s:) man:):" Makefile
	epatch "${FILESDIR}"/${PN}-0.2.8-use-QC-1.patch #316629
	epatch "${FILESDIR}"/${PN}-0.3.1-base-4.patch #424299
	epatch "${FILESDIR}"/${PN}-0.3.1-ghc-7.10.patch
	epatch "${FILESDIR}"/${PN}-0.3.1-containers.patch
}

src_compile() {
	emake -j1 || die "emake failed"
}

src_install() {
	dosbin hspace hscan hbal
	exeinto /usr/$(get_libdir)/ganeti/iallocators
	doexe hail
	doman man/*.1
	dodoc README NEWS AUTHORS
	use doc && dohtml -r apidoc/*
}
