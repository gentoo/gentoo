# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/dosfstools/dosfstools-3.0.27.ebuild,v 1.1 2015/04/03 07:05:29 vapier Exp $

EAPI="5"

inherit toolchain-funcs flag-o-matic eutils

DESCRIPTION="DOS filesystem tools - provides mkdosfs, mkfs.msdos, mkfs.vfat"
HOMEPAGE="http://www.daniel-baumann.ch/software/dosfstools/"
SRC_URI="https://github.com/dosfstools/dosfstools/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~arm-linux ~x86-linux"
RESTRICT="test" # there is no test target #239071

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.0.20-name-ext.patch
	sed -i \
		-e "/^PREFIX/s:=.*:= ${EPREFIX}/usr:" \
		-e '/^OPTFLAGS/d' \
		-e '/^DEBUGFLAGS/d' \
		-e "/\$(DOCDIR)/s:${PN}:${PF}:" \
		Makefile || die
	append-lfs-flags
	tc-export CC
}
