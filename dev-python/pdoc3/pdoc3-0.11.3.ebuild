# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..12} )

inherit distutils-r1 pypi

DESCRIPTION="Auto-generate API documentation for Python projects"
HOMEPAGE="https://pdoc3.github.io/pdoc/"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	dev-python/mako[${PYTHON_USEDEP}]
	>=dev-python/markdown-3.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -i \
		-e "/setuptools_git/d" \
		-e "/setuptools_scm/d" \
		setup.py || die

	sed -i \
		-e 's:test_lunr_search:_&:' \
		pdoc/test/__init__.py || die
}

distutils_enable_tests unittest
