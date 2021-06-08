# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

MY_PN=${PN/-/.}

DESCRIPTION="Create configuration schemas, and process and validate configurations."
HOMEPAGE="https://code.launchpad.net/lazr.config"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/zope-interface[${PYTHON_USEDEP}]
	dev-python/lazr-delegates[${PYTHON_USEDEP}]"
