# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Use Search URLs in your Django Haystack Application"
HOMEPAGE="
	https://pypi.org/project/dj-search-url/
	https://github.com/dstufft/dj-search-url/"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
