# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python module for downloading files"
HOMEPAGE="http://urlgrabber.baseurl.org"
SRC_URI="http://urlgrabber.baseurl.org/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ppc ppc64 ~x86"
IUSE=""

DEPEND="dev-python/pycurl[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
# Entire testsuite relies on connecting to the i'net

src_install() {
	distutils-r1_src_install

	# Fix "#! /usr/bin/python" to not end up with Python 3
	python_setup
	python_fix_shebang "${ED}"/usr/libexec/urlgrabber-ext-down
}
