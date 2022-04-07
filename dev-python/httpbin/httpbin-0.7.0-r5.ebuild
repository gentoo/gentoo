# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1

DESCRIPTION="HTTP Request and Response Service"
HOMEPAGE="
	https://github.com/postmanlabs/httpbin/
	https://pypi.org/project/httpbin/
"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~m68k ~riscv ~x86"

RDEPEND="
	dev-python/brotlicffi[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/itsdangerous[${PYTHON_USEDEP}]
	dev-python/markupsafe[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/werkzeug-2.0[${PYTHON_USEDEP}]
"

PATCHES=(
	# do not import raven if it's not going to be used
	# (upstream removed it completely in git anyway)
	"${FILESDIR}"/${P}-optional-raven.patch
	# fix tests with new versions of werkzeug
	"${FILESDIR}"/${P}-test-werkzeug.patch
	# use brotlicffi instead of brotlipy
	"${FILESDIR}"/${P}-brotlicffi.patch
	# fix compat with werkzeug 2.1
	# https://github.com/postmanlabs/httpbin/pull/674
	"${FILESDIR}"/${P}-werkzeug-2.1.patch
)

distutils_enable_tests unittest

src_prepare() {
	# a new version of flask or whatever converts relative redirects
	# to absolute; this package is dead anyway, so just skip
	# the relevant tests
	sed -e 's:test_redirect:_&:' \
		-e 's:test_relative:_&:' \
		-i test_httpbin.py || die

	distutils-r1_src_prepare
}
