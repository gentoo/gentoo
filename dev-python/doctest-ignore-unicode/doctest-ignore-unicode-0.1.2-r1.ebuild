# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Add flag to ignore unicode literal prefixes in doctests"
HOMEPAGE="https://pypi.org/project/doctest-ignore-unicode/ https://github.com/gnublade/doctest-ignore-unicode"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ~ppc64 ~riscv x86 ~amd64-linux ~x86-linux"

distutils_enable_tests nose
