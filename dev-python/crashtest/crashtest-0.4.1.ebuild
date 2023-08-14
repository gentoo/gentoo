# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Python library that makes exceptions handling and inspection easier"
HOMEPAGE="
	https://github.com/sdispater/crashtest/
	https://pypi.org/project/crashtest/
"
SRC_URI="
	https://github.com/sdispater/crashtest/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv ~s390 ~sparc x86"

distutils_enable_tests pytest
