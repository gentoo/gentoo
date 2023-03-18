# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Auto-generate API documentation for Python projects"
HOMEPAGE="https://pdoc3.github.io/pdoc/"

SLOT="0"
LICENSE="AGPL-3+"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/mako[${PYTHON_USEDEP}]
	>=dev-python/markdown-3.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-TST-use-explicit-ClassWithNew-instead-of-typing.Gene.patch"
)

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -i \
		-e "/setuptools_git/d" \
		-e "/setuptools_scm/d" \
		setup.py || die
}

distutils_enable_tests unittest
