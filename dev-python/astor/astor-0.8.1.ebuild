# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="Read/rewrite/write Python ASTs"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
HOMEPAGE="https://pypi.org/project/astor/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~sparc x86"
IUSE=""

distutils_enable_tests pytest

python_prepare_all() {
	# Tries to roundtrip every package on the system and is unreliable
	rm -f tests/test_rtrip.py || die

	distutils-r1_python_prepare_all
}
