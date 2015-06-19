# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/emacspeak-ss/emacspeak-ss-1.9.1.ebuild,v 1.14 2012/10/19 04:59:47 ago Exp $

EAPI=4

inherit eutils

DESCRIPTION="adds support for several speech synthesizers to emacspeak"
HOMEPAGE="http://leb.net/blinux/"
SRC_URI="http://leb.net/pub/blinux/emacspeak/blinux/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86 ppc"
IUSE=""

DEPEND=""
RDEPEND=">=app-accessibility/emacspeak-18"

src_prepare() {
	epatch "${FILESDIR}"/gentoo-apollo-fix.patch
	tc-export CC
}

src_install() {
	emake \
		prefix="${D}"/usr \
		man1dir="${D}"/usr/share/man/man1 \
		install
	dodoc CREDITS ChangeLog OtherSynthesizers TODO TROUBLESHOOTING README*
}
