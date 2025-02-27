# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 pypy3_11 python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Parse human-readable date/time strings"
HOMEPAGE="https://github.com/bear/parsedatetime"
SRC_URI="
	https://github.com/bear/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc64 ~riscv x86 ~arm64-macos ~x64-macos"

distutils_enable_tests pytest
