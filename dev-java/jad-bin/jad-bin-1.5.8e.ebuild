# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Jad - The fast JAva Decompiler"
HOMEPAGE="http://www.kpdus.com/jad.html"
SRC_URI="http://www.kpdus.com/jad/linux/jadls158.zip"
DEPEND="app-arch/unzip"
RDEPEND=""
KEYWORDS="x86 amd64 -ppc"
SLOT="0"
LICENSE="freedist"
IUSE=""

S=${WORKDIR}

RESTRICT="strip"

QA_PREBUILT="*"

src_install() {
	into /opt
	dobin jad || die "dobin failed"
	dodoc Readme.txt || die "dodoc failed"
}
