# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/cromwell-bin/cromwell-bin-2.31.ebuild,v 1.4 2011/04/10 14:36:44 ulm Exp $

inherit mount-boot

IUSE=""
DESCRIPTION="Xbox boot loader precompiled binaries from xbox-linux.org"
SRC_URI="mirror://sourceforge/xbox-linux/cromwell-${PV}.tar.gz"
HOMEPAGE="http://www.xbox-linux.org"
RESTRICT="${RESTRICT} strip"
DEPEND=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="-* x86"

S=${WORKDIR}/cromwell

src_install () {
	dodir /boot/${PN}
	insinto /boot/${PN}
	doins ${S}/image.bin ${S}/image_1024.bin ${S}/default.xbe || die
}
