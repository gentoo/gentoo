# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Yet another URL library"
HOMEPAGE="
	https://github.com/aio-libs/yarl/
	https://pypi.org/project/yarl/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	>=dev-python/multidict-4.0[${PYTHON_USEDEP}]
	>=dev-python/idna-2.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/cython
"

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/alabaster

src_configure() {
	set -- cython -3 yarl/_quoting_c.pyx
	echo "${*}" >&2
	"${@}" || die
}

python_test() {
	cd tests || die
	epytest --override-ini=addopts=
}
