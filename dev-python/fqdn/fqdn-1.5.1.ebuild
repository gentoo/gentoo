# Copyright 2018-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )

inherit distutils-r1

DESCRIPTION="RFC-compliant FQDN validation and manipulation for Python"
HOMEPAGE="https://github.com/ypcrts/fqdn"
SRC_URI="https://github.com/ypcrts/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/cached-property[${PYTHON_USEDEP}]
	' python3_7 pypy3)"

distutils_enable_tests pytest
distutils_enable_sphinx docs
