# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Jad - The fast JAva Decompiler"
HOMEPAGE="http://www.kpdus.com/jad.html"
SRC_URI="http://www.kpdus.com/jad/linux/jadls158.zip"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="freedist"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}

RESTRICT="strip"
QA_PREBUILT="*"

src_install() {
	into /opt
	dobin jad || die "dobin failed"
	dodoc Readme.txt || die "dodoc failed"
}
