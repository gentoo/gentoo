# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Client library for MSRP protocol and its relay extension"
HOMEPAGE="http://sipsimpleclient.org"
SRC_URI="http://download.ag-projects.com/MSRP/python-msrplib-${PV}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
IUSE=""

KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/python-application[${PYTHON_USEDEP}]
	dev-python/python-eventlib[${PYTHON_USEDEP}]
	dev-python/python-gnutls[${PYTHON_USEDEP}]
	dev-python/twisted-core[${PYTHON_USEDEP}]
	dev-python/twisted-names[${PYTHON_USEDEP}]
"
