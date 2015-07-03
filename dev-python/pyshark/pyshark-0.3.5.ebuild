# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyshark/pyshark-0.3.5.ebuild,v 1.2 2015/07/03 04:12:11 idella4 Exp $

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

DESCRIPTION="A Python wrapper for tshark output parsing"
HOMEPAGE="https://pypi.python.org/pypi/pyshark https://github.com/KimiNewt/pyshark"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
# See pyshark.egg-info/requires.txt
RDEPEND="dev-python/py[${PYTHON_USEDEP}]
	dev-python/logbook[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/trollius[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]
	net-analyzer/wireshark"
# Tests exlcuded in MANIFEST.in
