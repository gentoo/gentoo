# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Pidfile featuring stale detection and file-locking"
HOMEPAGE="
	https://github.com/trbs/pid/
	https://pypi.org/project/pid/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ~x86"

distutils_enable_tests pytest
