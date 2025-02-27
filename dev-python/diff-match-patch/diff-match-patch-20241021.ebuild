# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..13} pypy3 pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Diff, match and patch algorithms for plain text"
HOMEPAGE="
	https://github.com/diff-match-patch-python/diff-match-patch/
	https://pypi.org/project/diff-match-patch/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

distutils_enable_tests pytest
