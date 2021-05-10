# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
inherit distutils-r1

DESCRIPTION="Easy anonymous functions by partial application of operators"
HOMEPAGE="https://github.com/Suor/whatever"
SRC_URI="
	https://github.com/Suor/whatever/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

distutils_enable_tests pytest
