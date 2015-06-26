# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyshark/pyshark-0.3.5.ebuild,v 1.1 2015/06/26 06:39:28 patrick Exp $

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
RDEPEND="dev-python/futures[${PYTHON_USEDEP}]
	dev-python/logbook[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/trollius[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]
	net-analyzer/wireshark"

DOCS=( README.txt )
