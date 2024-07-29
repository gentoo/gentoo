# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9,10,11,12,13} )
PYPI_NO_NORMALIZE=1
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Python filtering architecture for the Courier MTA"
HOMEPAGE="https://pypi.org/project/courier-pythonfilter/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="mail-mta/courier"
