# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN=${PN/-/_}
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Jinja2 pluralize filters"
HOMEPAGE="
	https://github.com/audreyfeldroy/jinja2_pluralize/
	https://pypi.org/project/jinja2_pluralize/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/inflect[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
