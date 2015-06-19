# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/wavsplit/wavsplit-1.2.1-r1.ebuild,v 1.5 2010/07/30 00:28:14 ssuominen Exp $

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="WavSplit is a simple command line tool to split WAV files"
HOMEPAGE="http://sourceforge.net/projects/wavsplit/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
#-sparc, -amd64: 1.0: "Only supports PCM wave format" error message.
KEYWORDS="~amd64 -sparc x86"
IUSE=""

src_prepare() {
	emake clean || die
	epatch "${FILESDIR}"/${P}-Makefile.patch \
		"${FILESDIR}"/${P}-large-files.patch \
		"${FILESDIR}"/${P}-64bit.patch
}

src_compile() {
	emake CC="$(tc-getCC)" || die
}

src_test() { :; } #294302

src_install() {
	dobin wav{ren,split} || die
	doman wav{ren,split}.1 || die
	dodoc BUGS CHANGES CREDITS README{,.wavren}
}
