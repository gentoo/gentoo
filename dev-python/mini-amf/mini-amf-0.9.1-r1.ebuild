# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..8} )

inherit distutils-r1

DESCRIPTION="Minimal AMF encoder and decoder for Python"
HOMEPAGE="https://pypi.python.org/pypi/Mini-AMF"
SRC_URI="https://github.com/zackw/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc test"

RESTRICT="!test? ( test )"

RDEPEND="dev-python/defusedxml[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
	)"

distutils_enable_sphinx doc

PATCHES=( "${FILESDIR}"/mini-amf-0.9.1-setuptools-46-fix.patch )

python_test() {
	coverage run --source=miniamf setup.py test || die
}
