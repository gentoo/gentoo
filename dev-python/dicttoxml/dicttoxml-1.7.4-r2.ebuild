# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="Converts a Python dictionary or other data type to a valid XML string"
HOMEPAGE="https://github.com/quandyfactory/dicttoxml https://pypi.org/project/dicttoxml/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

PATCHES=(
	# https://github.com/quandyfactory/dicttoxml/pull/73/files
	"${FILESDIR}/${P}-py3.10.patch"
)
