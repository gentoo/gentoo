# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 pypi

DESCRIPTION="Python package for parsing and generating vCard and vCalendar files"
HOMEPAGE="https://eventable.github.io/vobject/
	https://pypi.org/project/vobject/
	https://github.com/eventable/vobject"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~riscv x86"

RDEPEND=">=dev-python/python-dateutil-2.4.0[${PYTHON_USEDEP}]"

DOCS=( ACKNOWLEDGEMENTS.txt README.md )

distutils_enable_tests unittest
