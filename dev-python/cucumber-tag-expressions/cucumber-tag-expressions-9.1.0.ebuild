# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=uv-build
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="Cucumber tag expression parser"
HOMEPAGE="
	https://github.com/cucumber/tag-expressions/
	https://pypi.org/project/cucumber-tag-expressions/
"
# no tests in sdist
SRC_URI="
	https://github.com/cucumber/tag-expressions/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/tag-expressions-${PV}/python"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="
	test? (
		>=dev-python/pyyaml-6.0.3[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
