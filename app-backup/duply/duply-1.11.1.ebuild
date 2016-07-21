# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit readme.gentoo

DESCRIPTION="A shell frontend for duplicity"
HOMEPAGE="http://duply.net"
SRC_URI="mirror://sourceforge/project/ftplicity/duply%20%28simple%20duplicity%29/1.11.x/${PN}_${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-text/txt2man"
RDEPEND="app-backup/duplicity"

S=${WORKDIR}/${PN}_${PV}

src_install() {
	dobin ${PN}
	./${PN} txt2man > ${PN}.1 || die
	doman ${PN}.1
	dodoc CHANGELOG.txt
	readme.gentoo_create_doc
}
