# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

MY_PN="${PN/-/_}"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Generic logging layer that to log to syslog, an open file handle or a file name"
HOMEPAGE="http://horms.net/projects/vanessa/"
SRC_URI="http://horms.net/projects/vanessa/download/${MY_PN}/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND=""

S="${WORKDIR}/${MY_P}"

src_install() {
	make DESTDIR="${D}" install || die "error installing"
	dodoc AUTHORS NEWS README TODO sample/*.c sample/*.h
}
