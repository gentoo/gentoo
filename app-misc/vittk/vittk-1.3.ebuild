# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/vittk/vittk-1.3.ebuild,v 1.2 2015/03/20 07:05:42 jlec Exp $

EAPI=4

inherit eutils autotools

DESCRIPTION="A front end for Taskwarrior (app-misc/task)"
HOMEPAGE="http://taskwarrior.org/wiki/taskwarrior/Vittk"
SRC_URI="http://taskwarrior.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/tcl:0"
RDEPEND="${DEPEND}
	dev-lang/tk:0
	app-misc/task"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-configure.patch \
		"${FILESDIR}"/${P}-makefile.patch \
		"${FILESDIR}"/${PN}-1.1.1-dirs.patch
	eautoreconf
}

src_configure() {
	econf --docdir="${EPREFIX}"/usr/share/doc/${PF}
}
