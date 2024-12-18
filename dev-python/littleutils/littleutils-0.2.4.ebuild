# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Small personal collection of Python utility functions"
HOMEPAGE="
	https://pypi.org/project/littleutils/
	https://github.com/alexmojaki/littleutils/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ppc ppc64 ~riscv ~s390 sparc x86"

python_test() {
	"${EPYTHON}" -m doctest -v littleutils/__init__.py ||
		die "Tests fail with ${EPYTHON}"
}
