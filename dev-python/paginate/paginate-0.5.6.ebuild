# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..11} )

inherit distutils-r1

DESCRIPTION="Divides large result sets into pages for easier browsing"
HOMEPAGE="
	https://github.com/Pylons/paginate/
	https://pypi.org/project/paginate/
"
SRC_URI="
	https://github.com/Pylons/paginate/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest
