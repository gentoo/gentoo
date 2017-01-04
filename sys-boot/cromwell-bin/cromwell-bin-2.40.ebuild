# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit mount-boot

IUSE=""
DESCRIPTION="Xbox boot loader precompiled binaries from xbox-linux.org"
SRC_URI="mirror://sourceforge/xbox-linux/cromwell-${PV}.tar.gz"
HOMEPAGE="https://sourceforge.net/projects/xbox-linux/"
RESTRICT="${RESTRICT} strip"
DEPEND=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="-* x86"

S=${WORKDIR}/cromwell-${PV}

src_install () {
	dodir /boot/${PN}
	insinto /boot/${PN}
	doins ${S}/cromwell.bin ${S}/cromwell_1024.bin ${S}/xromwell.xbe || die
}
