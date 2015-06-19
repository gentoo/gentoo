# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/dirdiff/dirdiff-2.1-r2.ebuild,v 1.6 2015/03/25 13:26:08 jlec Exp $

EAPI=5

inherit eutils flag-o-matic multilib toolchain-funcs

DESCRIPTION="A tool for differing and merging directories"
SRC_URI="http://samba.org/ftp/paulus/${P}.tar.gz"
HOMEPAGE="http://samba.org/ftp/paulus/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ppc x86"
IUSE=""

DEPEND="
	dev-lang/tk:0=
	dev-lang/tcl:0="
RDEPEND="${DEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-include.patch \
		"${FILESDIR}"/${P}-build.patch \
		"${FILESDIR}"/${P}-vcs.patch \
		"${FILESDIR}"/${P}-tcl8.6.patch \
		"${FILESDIR}"/${P}-funky-chars.patch
	tc-export CC
	append-cppflags -I"${EPREFIX}"/usr/include/tcl
}

src_install() {
	dobin dirdiff
	dolib.so libfilecmp.so.0.0
	dosym libfilecmp.so.0.0 /usr/$(get_libdir)/libfilecmp.so.0
	dosym libfilecmp.so.0.0 /usr/$(get_libdir)/libfilecmp.so
	dodoc README
}
