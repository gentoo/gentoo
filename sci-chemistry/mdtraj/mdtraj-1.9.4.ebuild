# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Read, write and analyze MD trajectories with only a few lines of Python code"
HOMEPAGE="http://mdtraj.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-python/astor[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/pytables[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-python/jupyter_client[${PYTHON_USEDEP}]
		dev-python/nbformat[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

# Tests fail (in previous ebuild versions they weren't even run
RESTRICT="test"

python_prepare() {
	sed -e "s:re.match('build.*(mdtraj.*)', output_dir).group(1):'.':g" \
		-i basesetup.py || die
	distutils-r1_python_prepare_all
}
