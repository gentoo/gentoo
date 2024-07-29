# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="easy-to-use, pythonic, and complete IMAP client library"
HOMEPAGE="
	https://github.com/mjs/imapclient/
	https://pypi.org/project/IMAPClient/
"
SRC_URI="
	https://github.com/mjs/imapclient/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE="doc examples"

distutils_enable_sphinx doc/src
distutils_enable_tests unittest

python_install_all() {
	distutils-r1_python_install_all
	use examples && dodoc -r examples
}
