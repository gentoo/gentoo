# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( pypy3 python3_{6,7,8,9} )

inherit distutils-r1

DESCRIPTION="Low-level, pure Python DBus protocol wrapper"
HOMEPAGE="https://gitlab.com/takluyver/jeepney"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="examples"

BDEPEND="
	test? ( dev-python/testpath[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest

distutils_enable_sphinx docs \
	dev-python/sphinx_rtd_theme

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r examples
	fi
	distutils-r1_python_install_all
}
