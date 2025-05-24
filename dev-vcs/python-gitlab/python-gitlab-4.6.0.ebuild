# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_PN="${PN/-/_}"
PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
inherit distutils-r1

DESCRIPTION="Python command line interface to gitlab API"
HOMEPAGE="https://github.com/python-gitlab/python-gitlab/"

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/python-gitlab/python-gitlab"
	inherit git-r3
else
	inherit pypi
	SRC_URI="$(pypi_sdist_url) -> ${P}.tar.gz"
	KEYWORDS="amd64"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

LICENSE="LGPL-3"
SLOT="0"

BDEPEND="test? (
		>=dev-python/pytest-console-scripts-1.3.1[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-5.2[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
		)"

RDEPEND=">=dev-python/requests-2.32.2[${PYTHON_USEDEP}]
	>=dev-python/requests-toolbelt-1.0.0[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# These tests do not make sense downstream
	"tests/smoke/test_dists.py"
	# Requires ability to run docker and pytest-docker
	# https://bugs.gentoo.org/938085
	"tests/functional"
)

python_install_all() {
	distutils-r1_python_install_all
	dodoc -r *.rst docs
}
