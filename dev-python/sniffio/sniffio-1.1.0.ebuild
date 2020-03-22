# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Sniff out which async library your code is running under"
HOMEPAGE="
	https://github.com/python-trio/sniffio
	https://pypi.org/project/sniffio
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="|| ( Apache-2.0 MIT )"
KEYWORDS="~amd64 ~x86"
SLOT="0"

RDEPEND="python_targets_python3_6? ( dev-python/contextvars[python_targets_python3_6] )"

DEPEND="test? ( dev-python/curio[${PYTHON_USEDEP}] )"

distutils_enable_sphinx docs/source dev-python/sphinxcontrib-trio
distutils_enable_tests pytest
