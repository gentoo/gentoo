# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/f2fs-tools/f2fs-tools-1.3.0.ebuild,v 1.1 2014/03/15 21:03:56 blueness Exp $

EAPI=5

inherit multilib

DESCRIPTION="Tools for Flash-Friendly File System (F2FS)"
HOMEPAGE="http://git.kernel.org/?p=linux/kernel/git/jaegeuk/f2fs-tools.git;a=summary"
SRC_URI="http://dev.gentoo.org/~blueness/f2fs-tools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"
IUSE=""

src_configure() {
	#This is required to install to /sbin, bug #481110
	econf --prefix=/ --includedir=/usr/include
}

src_install() {
	default
	rm -f "${ED}"/$(get_libdir)/libf2fs.{,l}a
}
