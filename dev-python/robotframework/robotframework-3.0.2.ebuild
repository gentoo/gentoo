# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# py2 only
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Test automation framework for acceptance testing & test-driven development"
HOMEPAGE="http://robotframework.org/ https://pypi.python.org/pypi/robotframework/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
