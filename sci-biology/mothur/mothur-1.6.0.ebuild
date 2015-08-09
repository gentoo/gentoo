# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit toolchain-funcs

DESCRIPTION="A suite of algorithms for ecological bioinformatics"
HOMEPAGE="http://www.mothur.org/"
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS="amd64 x86"

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}/mothur-v.${PV}"

src_prepare() {
	sed \
		-e 's/CC_OPTIONS =.*$/CC_OPTIONS = ${CXXFLAGS} /' \
		-e 's|CC = g++|CC = '$(tc-getCXX)'|' \
		-e '/^LNK_OPTIONS/s:$:${LDFLAGS}:g' \
		-i makefile || die
}

src_install() {
	dobin ${PN}
}
