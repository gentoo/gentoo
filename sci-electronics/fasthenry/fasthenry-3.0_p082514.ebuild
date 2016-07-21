# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit versionator

DESCRIPTION="Three dimensional inductance computation program, Whiteley Research version"
HOMEPAGE="http://www.wrcad.com/freestuff.html"
SRC_URI="http://www.wrcad.com/ftp/pub/fasthenry-3.0wr-082514.tar.gz"

LICENSE="all-rights-reserved"
RESTRICT="mirror bindist"

SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND=""

S=${WORKDIR}/fasthenry-3.0wr

src_compile() {
	emake all
}

src_install() {
	dobin bin/fasthenry
	dobin bin/zbuf
	dodoc -r doc/*
	dodoc -r examples
}
