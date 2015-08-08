# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils

DESCRIPTION="A Python extension module for cdb"
SRC_URI="http://pilcrow.madison.wi.us/python-cdb/${P}.tar.gz"
HOMEPAGE="http://pilcrow.madison.wi.us/#pycdb"

SLOT="0"
IUSE=""
LICENSE="GPL-2"
KEYWORDS="amd64 arm ia64 ppc sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos"

DEPEND="|| ( dev-db/cdb dev-db/tinycdb )"
RDEPEND="${DEPEND}"

DOCS="Example"

src_test() {
	testing() {
		"$(PYTHON)" setup.py build -b "build-${PYTHON_ABI}" install --home "${T}/test-${PYTHON_ABI}" || return 1
		# This is not really intended as test but it is better than nothing.
		PYTHONPATH="${T}/test-${PYTHON_ABI}/lib/python" "$(PYTHON)" < Example
	}
	python_execute_function testing
}
