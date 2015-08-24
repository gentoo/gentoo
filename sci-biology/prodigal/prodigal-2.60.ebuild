# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

MY_PV=${PV//./_}

DESCRIPTION="Prokaryotic Dynamic Programming Genefinding Algorithm"
HOMEPAGE="http://prodigal.ornl.gov/ https://code.google.com/p/prodigal/"
SRC_URI="https://prodigal.googlecode.com/files/prodigal.v${MY_PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/prodigal.v${MY_PV}"

src_prepare() {
	sed -i -e 's/CFLAGS=/CFLAGS+=/' -e 's/LDFLAGS=/LDFLAGS+=/' Makefile || die
}

src_install() {
	dobin prodigal
	dodoc README CHANGES
}
