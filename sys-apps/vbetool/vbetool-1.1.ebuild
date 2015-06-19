# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/vbetool/vbetool-1.1.ebuild,v 1.5 2013/03/21 06:03:18 patrick Exp $

EAPI="4"

inherit eutils autotools

DESCRIPTION="Run real-mode video BIOS code to alter hardware state (i.e. reinitialize video card)"
HOMEPAGE="http://www.codon.org.uk/~mjg59/vbetool/"
SRC_URI="http://www.codon.org.uk/~mjg59/vbetool/download/vbetool-1.1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="sys-libs/zlib
	sys-apps/pciutils
	>=dev-libs/libx86-1.1-r1"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.0-build.patch
	eaclocal # temp fix for #439614
	eautoreconf
}

src_configure() {
	econf --with-x86emu
}
