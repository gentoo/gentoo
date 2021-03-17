# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Library to extract data from Microsoft Excel spreadsheets"
HOMEPAGE="
	https://www.python-excel.org/
	https://github.com/python-excel/xlrd/"
SRC_URI="
	https://github.com/python-excel/xlrd/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"

distutils_enable_tests pytest
