# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Web APIs with django made easy"
HOMEPAGE="https://www.django-rest-framework.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

RDEPEND=">=dev-python/django-1.11[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

distutils_enable_tests setup.py
