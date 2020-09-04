# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..8} )
inherit distutils-r1

DESCRIPTION="Python ORM with beautiful query syntax"
HOMEPAGE="
	https://ponyorm.org/
	https://github.com/ponyorm/pony/"
SRC_URI="
	https://github.com/ponyorm/pony/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? ( $(python_gen_impl_dep sqlite) )"

distutils_enable_tests unittest
