# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/ijson/ijson-1.1.ebuild,v 1.2 2015/04/08 08:05:05 mgorny Exp $

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3} )

inherit distutils-r1

DESCRIPTION="Iterative JSON parser with a Pythonic interface"
HOMEPAGE="https://github.com/isagalaev/ijson http://pypi.python.org/pypi/ijson/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/yajl"
DEPEND="${RDEPEND}"
