# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Shell frontend for duplicity"
HOMEPAGE="https://duply.net"
SRC_URI="https://downloads.sourceforge.net/project/ftplicity/${PN}%20%28simple%20duplicity%29/$(ver_cut 1-2).x/${PN}_${PV}.tgz"
S="${WORKDIR}/${PN}_${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-text/txt2man"
RDEPEND="app-backup/duplicity"

src_install() {
	dobin ${PN}
	./${PN} txt2man > ${PN}.1 || die
	doman ${PN}.1
	dodoc CHANGELOG.txt
}
