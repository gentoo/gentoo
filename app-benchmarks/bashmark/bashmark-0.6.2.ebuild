# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-benchmarks/bashmark/bashmark-0.6.2.ebuild,v 1.6 2013/02/19 19:15:42 dirtyepic Exp $

EAPI=5

inherit eutils

DESCRIPTION="Geno's cross platform benchmarking suite"
HOMEPAGE="http://bashmark.coders-net.de"

SRC_URI="http://bashmark.coders-net.de/download/src/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-as-needed.patch
	epatch "${FILESDIR}"/${P}-gcc43.patch
	epatch "${FILESDIR}"/${P}-gcc47.patch
}

src_install() {
	dobin bashmark
	dodoc ChangeLog
}
