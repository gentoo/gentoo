# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Xen API SDK, for communication with Citrix XenServer and Xen Cloud Platform"
HOMEPAGE="http://community.citrix.com/display/xs/Download+SDKs"
SRC_URI="mirror://pypi/X/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
