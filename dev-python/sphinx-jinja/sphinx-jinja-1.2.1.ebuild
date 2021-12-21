# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=pyproject.toml
inherit distutils-r1

DESCRIPTION="A sphinx extension to include jinja based templates into a sphinx doc"
HOMEPAGE="https://github.com/tardyp/sphinx-jinja https://pypi.org/project/sphinx-jinja/"
SRC_URI="
	https://github.com/tardyp/sphinx-jinja/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/sphinx[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
