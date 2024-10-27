# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1

MY_PV=${PV}
MY_P=et_xmlfile-${MY_PV}

DESCRIPTION="An implementation of lxml.xmlfile for the standard library"
HOMEPAGE="
	https://pypi.org/project/et-xmlfile/
	https://foss.heptapod.net/openpyxl/et_xmlfile/
"
SRC_URI="
	https://foss.heptapod.net/openpyxl/et_xmlfile/-/archive/${MY_PV}/${MY_P}.tar.gz
		-> ${MY_P}.git.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"

RDEPEND="
	dev-python/lxml[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx doc \
	dev-python/sphinx-rtd-theme
