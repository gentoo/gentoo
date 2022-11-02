# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Add flag to ignore unicode literal prefixes in doctests"
HOMEPAGE="https://pypi.org/project/doctest-ignore-unicode/ https://github.com/gnublade/doctest-ignore-unicode"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ~ppc64 ~riscv x86 ~amd64-linux ~x86-linux"

distutils_enable_tests nose
