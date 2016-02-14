# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="A file archival tool which can also read and write tar files"
HOMEPAGE="https://www.gnu.org/software/cpio/cpio.html"
SRC_URI="mirror://gnu/cpio/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="nls"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.12-non-gnu-compilers.patch #275295
	epatch "${FILESDIR}"/${PN}-2.12-name-overflow.patch #572428
}

src_configure() {
	econf \
		$(use_enable nls) \
		--bindir="${EPREFIX}"/bin \
		--with-rmt="${EPREFIX}"/usr/sbin/rmt
}
