# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ospd/ospd-1.0.0.ebuild,v 1.1 2015/03/31 11:10:47 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DL_ID=1999

DESCRIPTION="Collection of scanner wrappers for OpenVAS"
HOMEPAGE="http://www.openvas.org/"
SRC_URI="http://wald.intevation.org/frs/download.php/${DL_ID}/${P/_beta/+beta}.tar.gz"

SLOT="0"
LICENSE="GPL-2+"
KEYWORDS=" ~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-python/paramiko[${PYTHON_USEDEP}]
	dev-python/pexpect[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${P/_beta/-beta}

_DOCS=( ChangeLog CHANGES README )

python_test() {
	esetup.py test
}
