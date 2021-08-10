# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

MY_P=python-${P}
DESCRIPTION="Core Schema"
HOMEPAGE="https://github.com/core-api/python-coreschema"
SRC_URI="
	https://github.com/core-api/python-coreschema/archive/${PV}.tar.gz
		-> ${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/jinja[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
