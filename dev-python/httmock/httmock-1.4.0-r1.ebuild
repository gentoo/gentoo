# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="A mocking library for requests"
HOMEPAGE="
	https://github.com/patrys/httmock/
	https://pypi.org/project/httmock/
"
SRC_URI="
	https://github.com/patrys/httmock/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/requests-1.0.0[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
