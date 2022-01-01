# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1

DESCRIPTION="A shell frontend for duplicity"
HOMEPAGE="http://duply.net"
SRC_URI="mirror://sourceforge/project/ftplicity/duply%20%28simple%20duplicity%29/2.2.x/${PN}_${PV}.tgz"

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
