# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/f2fs-tools/f2fs-tools-1.1.0-r1.ebuild,v 1.8 2013/09/05 13:27:13 ago Exp $

EAPI=4

DESCRIPTION="Tools for Flash-Friendly File System (F2FS)"
HOMEPAGE="http://sourceforge.net/projects/f2fs-tools/ http://git.kernel.org/?p=linux/kernel/git/jaegeuk/f2fs-tools.git;a=summary"
SRC_URI="http://dev.gentoo.org/~blueness/f2fs-tools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86"
IUSE=""

src_configure () {
	#This is required to install to /sbin, bug #481110
	econf --prefix=/
}
