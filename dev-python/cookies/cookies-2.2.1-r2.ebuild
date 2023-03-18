# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )
inherit distutils-r1 pypi

DESCRIPTION="Friendlier RFC 6265-compliant cookie parser/renderer"
HOMEPAGE="https://gitlab.com/sashahart/cookies"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

PATCHES=(
	# https://gitlab.com/sashahart/cookies/merge_requests/2
	"${FILESDIR}/cookies-2.2.1-fix-warnings.patch"

	"${FILESDIR}/cookies-2.2.1-tests.patch"
)

distutils_enable_tests pytest
