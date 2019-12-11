# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

MY_PN="${PN}-py3"
MY_PV="${PV/_p/.post}"

DESCRIPTION="Python SVG document creation library"
HOMEPAGE="https://github.com/alorence/pysvg-py3"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${MY_PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/${MY_PN}-${MY_PV}"
