# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="A mocking library for requests"
HOMEPAGE="https://github.com/patrys/httmock"
SRC_URI="https://github.com/patrys/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-python/requests-1.0.0[${PYTHON_USEDEP}]"

distutils_enable_tests setup.py
