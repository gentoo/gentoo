# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Python module for interacting with nested dicts"
HOMEPAGE="
	https://github.com/gmr/flatdict/
	https://pypi.org/project/flatdict/
"
SRC_URI="
	https://github.com/gmr/flatdict/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

distutils_enable_tests unittest
