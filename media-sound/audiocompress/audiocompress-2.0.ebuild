# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/audiocompress/audiocompress-2.0.ebuild,v 1.3 2009/06/09 08:57:38 fauli Exp $

inherit toolchain-funcs

MY_P=AudioCompress-${PV}

DESCRIPTION="Very gentle 1-band dynamic range compressor"
HOMEPAGE="http://beesbuzz.biz/code/"
SRC_URI="http://beesbuzz.biz/code/audiocompress/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

RDEPEND=""
DEPEND=""

S=${WORKDIR}/${MY_P}

src_compile() {
	emake \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" || die "emake failed"
}

src_install() {
	dobin AudioCompress || die "dobin failed"
	dodoc ChangeLog README TODO
}
