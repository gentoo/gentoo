# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="Paisley is a CouchDB client written in Python to be used within a Twisted application"
HOMEPAGE="https://launchpad.net/paisley https://pypi.python.org/pypi/paisley"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="dev-python/simplejson
	dev-python/twisted-core
	dev-python/twisted-web"
DEPEND="${RDEPEND}"
