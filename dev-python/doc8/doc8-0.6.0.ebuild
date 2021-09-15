# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Style checker for Sphinx (or other) RST documentation"
HOMEPAGE="http://git.openstack.org/cgit/stackforge/doc8"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"
IUSE=""

DEPEND=">=dev-python/pbr-1.6[${PYTHON_USEDEP}]"
RDEPEND="
	>=dev-python/pbr-1.6[${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	>=dev-python/restructuredtext-lint-0.7[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/stevedore[${PYTHON_USEDEP}]"

python_prepare_all() {
	sed -i '/^argparse/d' requirements.txt || die
	distutils-r1_python_prepare_all
}
