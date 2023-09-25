# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Read, write and analyze MD trajectories with only a few lines of Python code"
HOMEPAGE="https://mdtraj.org"

SLOT="0"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/astunparse[${PYTHON_USEDEP}]
	dev-python/astor[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/pytables[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-python/ipykernel[${PYTHON_USEDEP}]
		dev-python/jupyter-client[${PYTHON_USEDEP}]
		dev-python/nbformat[${PYTHON_USEDEP}]
		sci-libs/scikit-learn[${PYTHON_USEDEP}]
	)
"
# <cython-3 for bug #911646
BDEPEND="
	<dev-python/cython-3[${PYTHON_USEDEP}]
"

distutils_enable_tests --install pytest

PATCHES=(
	"${FILESDIR}/${P}-python311.patch"
)

python_prepare_all() {
	sed -e "s:re.match('build.*(mdtraj.*)', output_dir).group(1):'.':g" \
		-i basesetup.py || die
	distutils-r1_python_prepare_all
}
