# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/copyfs/copyfs-1.0.1.ebuild,v 1.1 2010/09/20 20:16:26 jer Exp $

EAPI="2"

inherit autotools eutils toolchain-funcs

DESCRIPTION="fuse-based filesystem for maintaining configuration files"
HOMEPAGE="http://invaders.mars-attacks.org/~boklm/copyfs/"
SRC_URI="${HOMEPAGE}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE=""

DEPEND=">=sys-fs/fuse-2.0
	sys-apps/attr"
RDEPEND="${DEPEND}"

src_prepare() {
	# this patch fixes sandbox violations
	epatch "${FILESDIR}"/${P}-gentoo.patch

	# this patch adds support for cleaning up the versions directory
	# the patch is experimental at best, but it's better than your
	# versions directory filling up with unused files
	#
	# patch by stuart@gentoo.org
	epatch "${FILESDIR}"/${PN}-1.0-unlink.patch
	eautoreconf
}

src_configure() {
	econf --bindir="${D}/usr/bin" --mandir="${D}/usr/share/man"
}

src_compile() {
	emake CC=$(tc-getCC) || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}
