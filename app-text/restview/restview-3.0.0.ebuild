# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..10} )
inherit distutils-r1 pypi

DESCRIPTION="reStructuredText viewer"
HOMEPAGE="https://mg.pov.lt/restview/ https://pypi.org/project/restview/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/readme_renderer[${PYTHON_USEDEP}]"

DOCS=( README.rst CHANGES.rst )

distutils_enable_tests pytest
