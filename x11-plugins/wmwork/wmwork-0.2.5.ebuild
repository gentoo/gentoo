# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="a dockapp that lets you easily track time spent on different projects"
HOMEPAGE="http://www.godisch.de/debian/wmwork"
SRC_URI="http://www.godisch.de/debian/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND=">=x11-libs/libXext-1.0.3
	>=x11-libs/libX11-1.1.1-r1
	>=x11-libs/libXpm-3.5.6"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

S=${WORKDIR}/${P}/src

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc ../{CHANGES,README}
}
