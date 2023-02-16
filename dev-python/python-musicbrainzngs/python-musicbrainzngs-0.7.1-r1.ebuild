# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Python bindings for the MusicBrainz NGS and the Cover Art Archive webservices"
HOMEPAGE="
	https://github.com/alastair/python-musicbrainzngs/
	https://pypi.org/project/musicbrainzngs/
"
SRC_URI="
	https://github.com/alastair/python-musicbrainzngs/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD-2 ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

distutils_enable_sphinx docs
distutils_enable_tests unittest

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	distutils-r1_python_install_all
}
