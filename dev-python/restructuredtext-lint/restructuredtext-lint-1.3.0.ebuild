# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Checks PyPI validity of reStructuredText"
HOMEPAGE="https://pypi.org/project/restructuredtext_lint/"

MY_P="restructuredtext_lint"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_P}/${MY_P}-${PV}.tar.gz"
S="${WORKDIR}/${MY_P}-${PV}"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	>=dev-python/docutils-0.11[${PYTHON_USEDEP}]
	<dev-python/docutils-1.0[${PYTHON_USEDEP}]"

python_test() {
	 nosetests -v || die
}
