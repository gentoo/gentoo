# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 optfeature pypi

DESCRIPTION="HTTP Request and Response Service"
HOMEPAGE="
	https://github.com/psf/httpbin/
	https://pypi.org/project/httpbin/
"

LICENSE="|| ( MIT ISC )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="test-rust"

RDEPEND="
	dev-python/brotlicffi[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	>=dev-python/flask-2.2.4[${PYTHON_USEDEP}]
	dev-python/itsdangerous[${PYTHON_USEDEP}]
	dev-python/markupsafe[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/werkzeug-2.2.2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		test-rust? (
			dev-python/flasgger[${PYTHON_USEDEP}]
		)
	)
"

distutils_enable_tests pytest

src_prepare() {
	local PATCHES=(
		# https://github.com/psf/httpbin/pull/44 (simplified)
		"${FILESDIR}/httpbin-0.10.1-optional-flasgger.patch"
	)

	# remove unnecessary deps
	sed -i -e '/greenlet/d' -e '/flasgger/d' pyproject.toml || die
	distutils-r1_src_prepare
}

pkg_postinst() {
	optfeature "Fancy index" dev-python/flasgger
}
