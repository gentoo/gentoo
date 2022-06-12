# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )
inherit distutils-r1

DESCRIPTION="Capture stdout, stderr easily"
HOMEPAGE="https://pypi.org/project/iocapture/"
SRC_URI="https://github.com/oinume/iocapture/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ppc ppc64 ~riscv ~s390 sparc x86"
LICENSE="MIT"

BDEPEND="
	test? (
		dev-python/six[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
