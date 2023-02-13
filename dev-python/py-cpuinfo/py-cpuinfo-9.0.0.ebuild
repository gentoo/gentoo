# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Get CPU info with pure Python 2 & 3"
HOMEPAGE="
	https://github.com/workhorsy/py-cpuinfo/
	https://pypi.org/project/py-cpuinfo/
"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"

distutils_enable_tests unittest
