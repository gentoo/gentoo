# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit toolchain-funcs

DESCRIPTION="vblade exports a block device using AoE"
HOMEPAGE="http://sf.net/projects/aoetools/"
SRC_URI="mirror://sourceforge/aoetools/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND="sys-apps/util-linux"

src_prepare() {
	sed -i -e 's,^CFLAGS.*,CFLAGS += -Wall,' \
		-e 's:-o vblade:${LDFLAGS} \0:' \
		makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dosbin vblade
	dosbin "${FILESDIR}"/vbladed
	doman vblade.8
	dodoc HACKING NEWS README
	newconfd "${FILESDIR}"/conf.d-vblade vblade
	newinitd "${FILESDIR}"/init.d-vblade.vblade0 vblade.vblade0
}
