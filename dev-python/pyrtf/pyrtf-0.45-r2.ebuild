# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )

inherit distutils-r1

MY_PN="PyRTF"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python library to produce RTF documents"
HOMEPAGE="http://pyrtf.sourceforge.net https://pypi.python.org/pypi/PyRTF"
SRC_URI="mirror://sourceforge/$PN/${MY_P}.tar.gz"

LICENSE="|| ( GPL-2 LGPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

S="${WORKDIR}/${MY_P}"
