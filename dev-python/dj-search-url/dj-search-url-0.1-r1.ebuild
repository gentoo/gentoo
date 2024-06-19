# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Use Search URLs in your Django Haystack Application"
HOMEPAGE="
	https://github.com/dstufft/dj-search-url/
	https://pypi.org/project/dj-search-url/
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc x86"
