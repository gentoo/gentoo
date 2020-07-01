# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 python3_7 python3_8 )
PYTHON_REQ_USE="ssl(+)"
DISTUTILS_USE_SETUPTOOLS=no
inherit distutils-r1

DESCRIPTION="Back up Untangle configurations via the web admin UI"
HOMEPAGE="http://michael.orlitzky.com/code/untangle-https-backup.xhtml"
SRC_URI="http://michael.orlitzky.com/code/releases/${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

src_install() {
	distutils-r1_src_install
	doman "doc/man8/${PN}.8"
	dodoc "doc/${PN}.example.ini"
}
