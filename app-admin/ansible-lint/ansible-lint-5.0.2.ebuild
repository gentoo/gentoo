# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Checks ansible playbooks for practices and behaviour that can be improved"
HOMEPAGE="https://github.com/ansible-community/ansible-lint"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# tests are broken at the moment
RESTRICT="test"

RDEPEND="
	app-admin/ansible[${PYTHON_USEDEP}]
	dev-python/enrich[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/wcmatch[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/setuptools_scm_git_archive[${PYTHON_USEDEP}]
	test? (
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	)"

distutils_enable_tests nose
