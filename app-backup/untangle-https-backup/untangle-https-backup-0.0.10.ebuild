# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )
PYTHON_REQ_USE="ssl(+)"
inherit distutils-r1

DESCRIPTION="Back up Untangle configurations via the web admin UI"
HOMEPAGE="http://michael.orlitzky.com/code/untangle-https-backup.php"
SRC_URI="http://michael.orlitzky.com/code/releases/${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	distutils-r1_src_install
	doman "doc/man8/${PN}.8"
	dodoc "doc/${PN}.example.ini"
}
