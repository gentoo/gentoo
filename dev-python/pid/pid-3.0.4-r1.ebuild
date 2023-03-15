# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Pidfile featuring stale detection and file-locking"
HOMEPAGE="https://pypi.org/project/pid/ https://github.com/trbs/pid/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"

distutils_enable_tests pytest
