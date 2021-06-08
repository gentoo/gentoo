# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..9} )

inherit distutils-r1

MY_PN="Frozen-Flask"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Freezes a Flask application into a set of static files"
HOMEPAGE="https://github.com/Frozen-Flask/Frozen-Flask https://pypi.org/project/Frozen-Flask/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="<dev-python/flask-2[${PYTHON_USEDEP}]"

distutils_enable_sphinx docs \
	dev-python/flask-sphinx-themes
distutils_enable_tests nose
