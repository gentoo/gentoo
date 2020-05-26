# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8,9} pypy3 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Easily test your HTTP library against a local copy of httpbin"
HOMEPAGE="https://github.com/kevin1024/pytest-httpbin
	https://pypi.org/project/pytest-httpbin/"
SRC_URI="https://github.com/kevin1024/pytest-httpbin/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~ppc ~ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/httpbin[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	test? ( dev-python/requests[${PYTHON_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}"/pytest-httpbin-1.0.0-pypy3-hang.patch
)

distutils_enable_tests pytest
