# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/genext2fs/genext2fs-1.4.1.ebuild,v 1.8 2014/08/09 12:05:37 ago Exp $

DESCRIPTION="generate ext2 file systems"
HOMEPAGE="http://sourceforge.net/projects/genext2fs"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~mips ppc sparc x86"
IUSE=""

DEPEND=""

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
