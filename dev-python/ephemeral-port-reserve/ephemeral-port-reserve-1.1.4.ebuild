# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Bind to an ephemeral port, force it into the TIME_WAIT state, and unbind it"
HOMEPAGE="
	https://pypi.org/project/ephemeral-port-reserve/
	https://github.com/Yelp/ephemeral-port-reserve/
"
SRC_URI="
	https://github.com/Yelp/ephemeral-port-reserve/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

distutils_enable_tests pytest
