# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1

DESCRIPTION="Python client for rqlite"
HOMEPAGE="
	https://github.com/rqlite/pyrqlite/
	https://pypi.org/project/pyrqlite/
"
SRC_URI="
	https://github.com/rqlite/pyrqlite/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	test? (
		>=dev-db/rqlite-6.7.0
	)
"
PATCHES=("${FILESDIR}/pyrqlite-2.2.3-test-support.patch")

distutils_enable_tests pytest
