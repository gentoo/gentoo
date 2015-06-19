# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/dvorakng/dvorakng-0.6.0.ebuild,v 1.11 2010/01/01 18:29:02 ssuominen Exp $

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
