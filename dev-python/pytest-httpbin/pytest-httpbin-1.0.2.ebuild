# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1

DESCRIPTION="Easily test your HTTP library against a local copy of httpbin"
HOMEPAGE="https://github.com/kevin1024/pytest-httpbin
	https://pypi.org/project/pytest-httpbin/"
SRC_URI="https://github.com/kevin1024/pytest-httpbin/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="
	dev-python/httpbin[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/requests[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/pytest-httpbin-1.0.0-pypy3-hang.patch
)

EPYTEST_DESELECT=(
	tests/test_server.py::test_redirect_location_is_https_for_secure_server
)

distutils_enable_tests pytest
