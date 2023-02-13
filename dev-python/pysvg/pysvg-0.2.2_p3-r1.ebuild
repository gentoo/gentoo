# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

MY_PN="${PN}-py3"
MY_PV="${PV/_p/.post}"

DESCRIPTION="Python SVG document creation library"
HOMEPAGE="https://github.com/alorence/pysvg-py3"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${MY_PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${MY_PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
