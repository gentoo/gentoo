# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit mount-boot

DESCRIPTION="Xbox boot loader precompiled binaries from xbox-linux.org"
HOMEPAGE="https://sourceforge.net/projects/xbox-linux/"
SRC_URI="mirror://sourceforge/xbox-linux/cromwell-${PV}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="-* x86"
IUSE=""
RESTRICT="${RESTRICT} strip"

DEPEND=""
RDEPEND=""

S=${WORKDIR}/cromwell-${PV}

src_install() {
	dodir /boot/${PN}
	insinto /boot/${PN}
	doins cromwell{,_1024}.bin xromwell.xbe
}
