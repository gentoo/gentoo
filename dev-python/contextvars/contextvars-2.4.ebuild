# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

DESCRIPTION="Backport of Python 3.7 contextvars module (PEP 567) for Python 3.6"
HOMEPAGE="https://github.com/MagicStack"
SRC_URI="https://github.com/MagicStack/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

RDEPEND="dev-python/immutables[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
