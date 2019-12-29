# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6,7,8} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="A library for stubbing in Python"
HOMEPAGE="https://github.com/alex/pretend/ https://pypi.org/project/pretend/"
SRC_URI="https://github.com/alex/pretend/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
