# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit unpacker

DESCRIPTION="shell script that generates a self-extractible tar.gz"
HOMEPAGE="http://www.megastep.org/makeself/"
SRC_URI="http://www.megastep.org/makeself/${P}.run"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="sys-apps/gentoo-functions"

S=${WORKDIR}

src_install() {
	dobin makeself-header.sh makeself.sh "${FILESDIR}"/makeself-unpack || die
	dosym makeself.sh /usr/bin/makeself
	doman makeself.1
	dodoc README TODO makeself.lsm
}
