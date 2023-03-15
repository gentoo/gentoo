# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..10} )
inherit distutils-r1 pypi

DESCRIPTION="Enables you to generate KML with as little effort as possible"
HOMEPAGE="https://pypi.org/project/simplekml/"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
