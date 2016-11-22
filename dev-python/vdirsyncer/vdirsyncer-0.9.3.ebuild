# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

PYTHON_COMPAT=( python3_4 )

inherit distutils-r1

DESCRIPTION="Synchronize calendars and contacts"
HOMEPAGE="https://github.com/pimutils/vdirsyncer"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

DEPEND="dev-python/setuptools_scm[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/click-5.0[${PYTHON_USEDEP}]
	>=dev-python/click-log-0.1.3[${PYTHON_USEDEP}]
	>=dev-python/click-threading-0.1.2[${PYTHON_USEDEP}]
	>=dev-python/requests-2.4.1[${PYTHON_USEDEP}]
	!=dev-python/requests-2.9.0[${PYTHON_USEDEP}]
	=dev-python/lxml-3.4.4[${PYTHON_USEDEP}]
	>=dev-python/requests-toolbelt-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/atomicwrites-0.1.7[${PYTHON_USEDEP}]"

DOCS=( AUTHORS.rst CHANGELOG.rst CONTRIBUTING.rst README.rst config.example )
