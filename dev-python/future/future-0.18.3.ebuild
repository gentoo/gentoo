# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Easy, clean, reliable Python 2/3 compatibility"
HOMEPAGE="
	https://python-future.org/
	https://github.com/PythonCharmers/python-future/
	https://pypi.org/project/future/
"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-0.18.3-tests.patch.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
		' 'python*')
	)
"

PATCHES=(
	"${WORKDIR}"/${PN}-0.18.3-tests.patch
	"${FILESDIR}"/${PN}-0.18.2-py39.patch
	"${FILESDIR}"/${PN}-0.18.2-py39-fileurl.patch
	"${FILESDIR}"/${PN}-0.18.2-py3.10.patch
)

EPYTEST_DESELECT=(
	# tests requiring network access
	tests/test_future/test_requests.py
	tests/test_future/test_standard_library.py::TestStandardLibraryReorganization::test_moves_urllib_request_http
	tests/test_future/test_standard_library.py::TestStandardLibraryReorganization::test_urllib_request_http
)

distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/sphinx-bootstrap-theme
