# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1

DESCRIPTION="HTTP Request and Response Service"
HOMEPAGE="https://github.com/postmanlabs/httpbin
	https://pypi.org/project/httpbin/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="
	dev-python/brotlicffi[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/itsdangerous[${PYTHON_USEDEP}]
	dev-python/markupsafe[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/werkzeug-0.14.1[${PYTHON_USEDEP}]"

PATCHES=(
	# do not import raven if it's not going to be used
	# (upstream removed it completely in git anyway)
	"${FILESDIR}"/httpbin-0.7.0-optional-raven.patch
	# fix tests with new versions of werkzeug
	"${FILESDIR}"/httpbin-0.7.0-test-werkzeug.patch
	# use brotlicffi instead of brotlipy
	"${FILESDIR}"/httpbin-0.7.0-brotlicffi.patch
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
