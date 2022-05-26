# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Jinja2 pluralize filters"
HOMEPAGE="
	https://github.com/audreyfeldroy/jinja2_pluralize/
	https://pypi.org/project/jinja2_pluralize/
"

SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/inflect[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
