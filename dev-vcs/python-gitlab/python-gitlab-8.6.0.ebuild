# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-/_}"
PYTHON_COMPAT=( python3_{13..15} )
DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/python-gitlab/python-gitlab
inherit distutils-r1

DESCRIPTION="Python command line interface to gitlab API"
HOMEPAGE="https://github.com/python-gitlab/python-gitlab/"

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/python-gitlab/python-gitlab"
	inherit git-r3
else
	inherit pypi
	KEYWORDS="~amd64"
fi

LICENSE="LGPL-3"
SLOT="0"

RDEPEND="
	>=dev-python/requests-2.34.2[${PYTHON_USEDEP}]
	>=dev-python/requests-toolbelt-1.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/anyio[${PYTHON_USEDEP}]
		>=dev-python/pytest-console-scripts-1.4.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-1.7.0[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-6.0.3[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
		dev-python/respx[${PYTHON_USEDEP}]
		dev-python/trio[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=(pytest-{cov,console-scripts})

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# These tests do not make sense downstream
	"tests/smoke/test_dists.py"
	# Requires ability to run docker and pytest-docker
	# https://bugs.gentoo.org/938085
	"tests/functional"
	# Requires unpackaged gql (Used optionally for graphql support at runtime)
	"tests/unit/test_graphql.py"
)

python_install_all() {
	distutils-r1_python_install_all
	dodoc -r *.rst docs
}
