# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_{6,7}} )

inherit distutils-r1

DESCRIPTION="A CSS Cascading Style Sheets library (fork of cssutils)"
HOMEPAGE="https://pypi.org/project/css-parser/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm x86"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
