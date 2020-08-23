# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="Use Database URLs in your Django Application"
HOMEPAGE="
	https://pypi.org/project/dj-database-url/
	https://github.com/jacobian/dj-database-url"
SRC_URI="
	https://github.com/jacobian/dj-database-url/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

distutils_enable_tests unittest
