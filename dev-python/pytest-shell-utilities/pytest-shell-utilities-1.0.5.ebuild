# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Pytest plugin to simplify running shell commands against the system"
HOMEPAGE="
	https://pypi.org/project/pytest-shell-utilities/
	https://github.com/saltstack/pytest-shell-utilities
"
SRC_URI="
	https://github.com/saltstack/pytest-shell-utilities/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	dev-python/pytest-helpers-namespace[${PYTHON_USEDEP}]
	dev-python/pytest-skip-markers[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/pyfakefs[${PYTHON_USEDEP}]
		dev-python/pytest-subtests[${PYTHON_USEDEP}]
		!!<dev-python/pytest-salt-factories-0.912.2
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -e '/setuptools-declarative-requirements/d' -i setup.cfg || die
	distutils-r1_src_prepare
}

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
