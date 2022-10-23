# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 optfeature

DESCRIPTION="IPython-enabled pdb"
HOMEPAGE="
	https://github.com/gotcha/ipdb/
	https://pypi.org/project/ipdb/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ppc64 ~riscv ~sparc x86"

RDEPEND="
	>=dev-python/ipython-7.17[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/tomli[${PYTHON_USEDEP}]
	)
"

DOCS=( AUTHORS HISTORY.txt README.rst )

PATCHES=(
	"${FILESDIR}"/${P}-tomli.patch
)

distutils_enable_tests unittest

pkg_postinst() {
	optfeature "pyproject.toml support" dev-python/tomli
}
