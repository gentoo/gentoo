# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1

DESCRIPTION="enables you to generate KML with as little effort as possible"
HOMEPAGE="https://pypi.org/project/simplekml/"
#SRC_URI="https://files.pythonhosted.org/packages/62/88/feeb5ac5ae528c81daed9fe9864ec42496b80ffbcf83ac60bb6feb5b7f80/${P}.tar.gz"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
