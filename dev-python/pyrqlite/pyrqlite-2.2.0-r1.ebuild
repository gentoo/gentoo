# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
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

distutils_enable_tests pytest

src_prepare() {
	# siiigh
	cat >> setup.cfg <<-EOF
		[metadata]
		version = ${PV}
	EOF
	distutils-r1_src_prepare
}
