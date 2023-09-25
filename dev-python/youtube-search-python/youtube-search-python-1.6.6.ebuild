# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Get YouTube video information using link WITHOUT YouTube Data API v3"
HOMEPAGE="https://github.com/alexmercerind/youtube-search-python/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	dev-python/httpx[${PYTHON_USEDEP}]
	net-misc/yt-dlp[${PYTHON_USEDEP}]
"
