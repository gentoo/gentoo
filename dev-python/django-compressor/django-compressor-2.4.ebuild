# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1

DESCRIPTION="Compresses linked and inline JavaScript or CSS into single cached files."
HOMEPAGE="https://django-compressor.readthedocs.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN/-/_}/${P/-/_}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
DEPEND="dev-python/django-appconf[${PYTHON_USEDEP}]
	dev-python/rcssmin[${PYTHON_USEDEP}]
	dev-python/rjsmin[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"

S="${WORKDIR}/${P/-/_}"
