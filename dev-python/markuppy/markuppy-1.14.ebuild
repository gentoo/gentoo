# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

MY_PN="MarkupPy"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="MarkupPy - An HTML/XML generator"
HOMEPAGE="https://pypi.org/project/MarkupPy/ https://github.com/tylerbakke/MarkupPy"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

S="${WORKDIR}/${MY_P}"

SLOT="0"
LICENSE="BSD-2"
KEYWORDS="~amd64"

# MarkupPy does not have any test suite
RESTRICT="test"
