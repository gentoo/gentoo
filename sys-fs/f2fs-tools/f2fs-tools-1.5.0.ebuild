# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib

DESCRIPTION="Tools for Flash-Friendly File System (F2FS)"
HOMEPAGE="https://git.kernel.org/?p=linux/kernel/git/jaegeuk/f2fs-tools.git;a=summary"
SRC_URI="https://dev.gentoo.org/~blueness/f2fs-tools/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0/0"
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
