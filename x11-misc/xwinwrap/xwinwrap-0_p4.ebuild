# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xwinwrap/xwinwrap-0_p4.ebuild,v 1.2 2012/12/23 20:17:59 ulm Exp $

EAPI=4

inherit toolchain-funcs vcs-snapshot

DESCRIPTION="replace a desktop background with a movie or screensaver"
HOMEPAGE="http://tech.shantanugoel.com/projects/linux/shantz-xwinwrap"
SRC_URI="http://bazaar.launchpad.net/~shantanu-goel/xwinwrap/devel/tarball/4 -> ${P}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libXext
	x11-libs/libXrender"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${P}/${PN}/devel

src_compile() {
	local cmd="$(tc-getCC) -Wall ${CFLAGS} ${PN}.c -o ${PN} ${LDFLAGS} \
		 $(pkg-config --libs x11 xext xrender)"
	echo $cmd
	$cmd || die
}

src_install() {
	dobin ${PN}
}
