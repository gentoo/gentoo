# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

MY_PV="${PV:0:4}.${PV:4}"

DESCRIPTION="Procmail Module Library is a collection of modules for Procmail"
HOMEPAGE="http://freshmeat.net/projects/procmail-lib"
SRC_URI="mirror://nongnu/${PN}/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND="mail-filter/procmail"

S="${WORKDIR}/${PN}-${MY_PV}"

src_install() {
	emake DESTDIR="${D}" prefix=/usr install || die "make install failed"
	mv "${D}"/usr/share/doc/"${PN}" "${D}"/usr/share/doc/"${PF}"
}
