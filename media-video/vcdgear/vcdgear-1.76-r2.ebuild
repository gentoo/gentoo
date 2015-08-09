# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

QA_PRESTRIPPED=/opt/vcdgear/vcdgear
QA_FLAGS_IGNORED=/opt/vcdgear/vcdgear

STAMP=040415
DESCRIPTION="extract MPEG streams from CD images, convert VCD files to MPEG, correct MPEG errors, and more"
HOMEPAGE="http://www.vcdgear.com/"
SRC_URI="http://www.vcdgear.com/files/vcdgear${PV//.}-${STAMP}_linux.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="mirror bindist"

RDEPEND="virtual/libstdc++:3.3"
DEPEND=""

S=${WORKDIR}/${PN}

src_install() {
	insinto /opt/vcdgear
	doins -r * || die "doins"
	fperms a+rx /opt/vcdgear/vcdgear
	dodir /opt/bin
	dosym /opt/vcdgear/vcdgear /opt/bin/vcdgear
}
