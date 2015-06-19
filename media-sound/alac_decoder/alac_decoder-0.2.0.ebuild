# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/alac_decoder/alac_decoder-0.2.0.ebuild,v 1.1 2010/05/07 11:57:38 sbriesen Exp $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="Basic decoder for Apple Lossless Audio Codec files (ALAC)"
HOMEPAGE="http://craz.net/programs/itunes/alac.html"
SRC_URI="http://craz.net/programs/itunes/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~ppc-macos ~x86-solaris"
IUSE=""

RDEPEND=""
DEPEND="sys-apps/sed"

S=${WORKDIR}/${PN}

src_prepare() {
	sed -i -e "s:\(-o alac\):\$(LDFLAGS) \1:g" Makefile || die "sed failed"
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	dobin alac || die "dobin failed"
	dodoc README
}
