# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/vobcopy/vobcopy-1.2.0.ebuild,v 1.6 2011/02/12 19:15:04 armin76 Exp $

EAPI=2
inherit toolchain-funcs

IUSE=""

DESCRIPTION="copies DVD .vob files to harddisk, decrypting them on the way"
HOMEPAGE="http://lpn.rnbhq.org/"
SRC_URI="http://lpn.rnbhq.org/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"

DEPEND=">=media-libs/libdvdread-0.9.4"

src_configure() {
	tc-export CC
	./configure.sh --with-lfs
}

src_install() {
	dobin vobcopy || die "dobin failed"
	doman vobcopy.1 || die "doman failed"
	dodoc Changelog README Release-Notes TODO alternative_programs.txt \
		|| die "dodoc failed"
}
