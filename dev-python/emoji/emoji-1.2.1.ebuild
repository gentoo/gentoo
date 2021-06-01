# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1

DESCRIPTION="Emoji for Python"
HOMEPAGE="https://github.com/carpedm20/emoji/"
SRC_URI="https://github.com/carpedm20/emoji/archive/refs/tags/v.${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-v.${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

distutils_enable_tests pytest
