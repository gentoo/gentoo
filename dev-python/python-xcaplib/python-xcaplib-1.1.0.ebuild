# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_REQ_USE="ssl,xml"
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Python library for managing XML documents on XCAP server"
HOMEPAGE="http://sipsimpleclient.org"
SRC_URI="http://download.ag-projects.com/XCAP/python-xcaplib-${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/python-application[${PYTHON_USEDEP}]
"
