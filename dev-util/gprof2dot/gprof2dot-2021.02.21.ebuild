# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE='xml'
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

MY_PV=${PV//.0/.}
MY_P=${PN}-${MY_PV}
DESCRIPTION="Converts profiling output to dot graphs"
HOMEPAGE="https://github.com/jrfonseca/gprof2dot"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"/${MY_P}
