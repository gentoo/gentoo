# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="A Python data validation library"
HOMEPAGE="https://github.com/alecthomas/voluptuous/"
SRC_URI="
	https://github.com/alecthomas/voluptuous/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"

PATCHES=(
	"${FILESDIR}"/${PN}-0.11.5-fix-doctest.patch
)

distutils_enable_tests pytest
