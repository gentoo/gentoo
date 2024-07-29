# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1

DESCRIPTION="A convenient function to download to a file using requests"
HOMEPAGE="
	https://github.com/takluyver/requests_download
	https://pypi.org/project/requests_download/
"
SRC_URI="
	https://github.com/takluyver/requests_download/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~mips ~x86"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
"

# there are no tests upstream
RESTRICT="test"

DOCS=( README.rst )
