# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="Organize changelog directives in Sphinx docs"
HOMEPAGE="https://github.com/davidism/sphinxcontrib-log-cabinet"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P/_/-}.tar.gz"
S="${WORKDIR}/${P/_/-}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="dev-python/namespace-sphinxcontrib[${PYTHON_USEDEP}]"

python_install_all() {
	distutils-r1_python_install_all
	find "${ED}" -name '*.pth' -delete || die
}
