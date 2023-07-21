# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
PYPI_NO_NORMALIZE=1
inherit distutils-r1 pypi

DESCRIPTION=" setuptools plugin for building mo files"
HOMEPAGE="
	https://pypi.org/project/setuptools-gettext/
	https://github.com/breezy-team/setuptools-gettext
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	sys-devel/gettext
"
