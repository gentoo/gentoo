# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/transifex-client/transifex-client-0.11.1_beta.ebuild,v 1.2 2015/04/08 07:30:36 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PV=${PV/_/.}
MY_P=${PN}-${MY_PV}

DESCRIPTION="A command line interface for Transifex"
HOMEPAGE="http://pypi.python.org/pypi/transifex-client http://www.transifex.net/"
SRC_URI="mirror://pypi/t/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

S="${WORKDIR}/${MY_P}"
