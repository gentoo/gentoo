# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_5 python3_6 python3_7 python3_8 )
inherit distutils-r1

DESCRIPTION="Django-filter is a reusable Django application for allowing users to filter querysets dynamically"
HOMEPAGE="https://github.com/carltongibson/django-filter"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-python/django-2.2[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
    dev-python/setuptools[${PYTHON_USEDEP}]"