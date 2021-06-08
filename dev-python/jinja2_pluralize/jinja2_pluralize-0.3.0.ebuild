# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Jinja2 pluralize filters"
HOMEPAGE="https://github.com/audreyr/jinja2_pluralize"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/inflect[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]"

distutils_enable_tests setup.py
