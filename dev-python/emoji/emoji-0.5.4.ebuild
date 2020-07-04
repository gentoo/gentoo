# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7,8})

inherit distutils-r1

DESCRIPTION="Emoji for Python"
HOMEPAGE="https://github.com/carpedm20/emoji/"
LICENSE="BSD"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

BDEPEND=""
RDEPEND=""
