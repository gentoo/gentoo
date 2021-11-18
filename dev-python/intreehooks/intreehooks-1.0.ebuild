# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} pypy3 )
inherit distutils-r1

DESCRIPTION="Load a PEP 517 backend from inside the source tree"
HOMEPAGE="
	https://pypi.org/project/intreehooks/
	https://github.com/takluyver/intreehooks/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ppc ~ppc64 sparc x86"
IUSE="examples"

RDEPEND="
	dev-python/toml[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_prepare_all() {
	# replace pytoml with toml
	sed -e 's:pytoml:toml:' \
		-i setup.py intreehooks.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	local -a DOCS=( README.rst )
	use examples && dodoc -r examples

	distutils-r1_python_install_all
}
