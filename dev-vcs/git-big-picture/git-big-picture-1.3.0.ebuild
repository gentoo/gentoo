# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..12} )

inherit distutils-r1 pypi

DESCRIPTION="Visualization tool for Git repositories"
HOMEPAGE="https://github.com/git-big-picture/git-big-picture"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# NOTE: dev-util/cram explictly does not need [${PYTHON_USEDEP}]
#       since test.cram is a shell session and not Python code
DEPEND="
	test? (
		dev-python/parameterized[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-util/cram
	)
"
# NOTE: No need for "[python]" or "[${PYTHON_USEDEP}]" with any of
#       these since they are invoked using subprocess
RDEPEND="
	dev-vcs/git
	media-gfx/graphviz[svg]
"

RESTRICT="!test? ( test )"

python_test() {
	pytest -vv test.py || die "Tests fail with ${EPYTHON}"
	cram test.cram || die "Tests fail with ${EPYTHON}"
}
