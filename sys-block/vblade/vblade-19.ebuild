# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/vblade/vblade-19.ebuild,v 1.5 2011/07/17 11:07:07 xarthisius Exp $

inherit eutils

DESCRIPTION="vblade exports a block device using AoE"
HOMEPAGE="http://sf.net/projects/aoetools/"
#SRC_URI="mirror://sourceforge/aoetools/${P}.tar.gz"
SRC_URI="mirror://sourceforge/aoetools/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""
DEPEND=""
RDEPEND="${DEPEND}
		sys-apps/util-linux"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# messy tarball
	make clean  || die "Failed to clean up source"
	sed -i 's,^CFLAGS.*,CFLAGS += -Wall,' makefile || die "Failed to clean up makefile"
}
src_compile() {
	emake || die "emake failed"
}

src_install() {
	into /usr
	doman vblade.8
	dodoc HACKING NEWS README
	dosbin vblade
	dosbin "${FILESDIR}"/vbladed
	newconfd "${FILESDIR}"/conf.d-vblade vblade
	newinitd "${FILESDIR}"/init.d-vblade.vblade0 vblade.vblade0
}
