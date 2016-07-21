# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_P="${P/_/}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="A fully functional X client library for Python, written in Python"
HOMEPAGE="http://python-xlib.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ~ppc64 x86"
IUSE=""

RESTRICT_PYTHON_ABIS="3.*"

PYTHON_MODNAME="Xlib"

src_test() {
	cd test
	testing() {
		local return_status="0" test
		for test in *.py; do
			echo "Running ${test}..."
			PYTHONPATH="../build-${PYTHON_ABI}/lib" "$(PYTHON)" "${test}" || return_status="1"
		done
		return "${return_status}"
	}
	python_execute_function testing
}
