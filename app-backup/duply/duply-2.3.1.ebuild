# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A shell frontend for duplicity"
HOMEPAGE="https://duply.net"
SRC_URI="https://jztkft.dl.sourceforge.net/project/ftplicity/duply%20%28simple%20duplicity%29/2.3.x/duply_2.3.1.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-text/txt2man"
RDEPEND="app-backup/duplicity"

S="${WORKDIR}/${PN}_${PV}"

src_install() {
	dobin ${PN}
	./${PN} txt2man > ${PN}.1 || die
	doman ${PN}.1
	dodoc CHANGELOG.txt
}
