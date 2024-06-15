# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..12} )

inherit distutils-r1 pypi

DESCRIPTION="Auto-generate API documentation for Python projects"
HOMEPAGE="https://pdoc3.github.io/pdoc/"
SRC_URI+="
	https://github.com/pdoc3/pdoc/commit/14cd51c1b7431cdec5c3e7510b8a0e3b66c2f7d4.patch
		-> ${PN}-0.10.0-fix-deprecation-warnings.patch
"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	dev-python/mako[${PYTHON_USEDEP}]
	>=dev-python/markdown-3.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-TST-use-explicit-ClassWithNew-instead-of-typing.Gene.patch"
	"${FILESDIR}/${PN}-0.10.0-update-tests.patch"
	"${DISTDIR}"/${PN}-0.10.0-fix-deprecation-warnings.patch
)

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -i \
		-e "/setuptools_git/d" \
		-e "/setuptools_scm/d" \
		setup.py || die
}

distutils_enable_tests unittest
