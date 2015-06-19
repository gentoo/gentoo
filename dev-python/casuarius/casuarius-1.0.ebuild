# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/casuarius/casuarius-1.0.ebuild,v 1.1 2012/12/06 18:12:11 bicatali Exp $

EAPI=4

PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython 2.7-pypy-*"
PYTHON_TESTS_RESTRICTED_ABIS="2.6"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="Cython wrapper for the Cassowary incremental constraint solver"
HOMEPAGE="https://github.com/enthought/casuarius"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

RDEPEND=""
DEPEND=">=dev-python/cython-0.15.1"
