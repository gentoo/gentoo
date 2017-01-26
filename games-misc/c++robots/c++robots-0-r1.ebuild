# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="ongoing 'King of the Hill' (KotH) tournament"
HOMEPAGE="http://www.gamerz.net/c++robots/"
SRC_URI="http://www.gamerz.net/c++robots/c++robots.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE="static"

S=${WORKDIR}/${PN}

PATCHES=(
	"${FILESDIR}/proper-coding.patch"
)

src_compile() {
	local myldflags="${LDFLAGS}"
	use static && myldflags="${myldflags} -static"
	emake CFLAGS="${CFLAGS}" LDFLAGS="${myldflags}"
}

src_install() {
	dobin combat cylon target tracker
	dodoc README
}
