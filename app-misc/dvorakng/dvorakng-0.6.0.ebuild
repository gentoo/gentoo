# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="Dvorak typing tutor"
HOMEPAGE="http://freshmeat.net/projects/dvorakng/?topic_id=71%2C861"
SRC_URI="http://www.free.of.pl/n/nopik/${P}rc1.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""
DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"

S=${WORKDIR}/dvorakng

src_compile() {
	emake CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}" || die "emake failed"
}

src_install() {
	dobin dvorakng || die "dobin failed"
	dodoc README TODO || die "dodoc failed"
}
