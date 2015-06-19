# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-daemon/python-daemon-1.6.ebuild,v 1.8 2014/08/10 21:18:39 slyfox Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
DISTUTILS_SRC_TEST="setup.py"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils

DESCRIPTION="Library to implement a well-behaved Unix daemon process"
HOMEPAGE="http://pypi.python.org/pypi/python-daemon"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="test"

RDEPEND=">=dev-python/lockfile-0.9"
DEPEND="${RDEPEND}
	dev-python/setuptools
	test? ( dev-python/minimock )"

PYTHON_MODNAME="daemon"
DOCS="ChangeLog"
