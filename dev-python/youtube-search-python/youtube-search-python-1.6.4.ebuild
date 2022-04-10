# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Get YouTube video information using link WITHOUT YouTube Data API v3"
HOMEPAGE="https://github.com/alexmercerind/youtube-search-python/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/httpx[${PYTHON_USEDEP}]
	net-misc/yt-dlp[${PYTHON_USEDEP}]
"
