# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="ASGI utilities (successor to WSGI)"
HOMEPAGE="
	https://asgi.readthedocs.io/en/latest/
	https://github.com/django/asgiref/
	https://pypi.org/project/asgiref/"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 ~sparc x86"

BDEPEND="
	test? ( dev-python/pytest-asyncio[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest
