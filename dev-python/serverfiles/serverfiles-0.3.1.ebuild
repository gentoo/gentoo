# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Utility for accessing HTTP server and storing files locally for reuse"
HOMEPAGE="https://github.com/biolab/serverfiles"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-python/requests-2.11.1[${PYTHON_USEDEP}]"
BDEPEND="dev-python/setuptools_scm[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
