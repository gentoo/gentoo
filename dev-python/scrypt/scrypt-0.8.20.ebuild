# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1

DESCRIPTION="Bindings for the scrypt key derivation function library"
HOMEPAGE="https://github.com/holgern/py-scrypt/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv sparc x86 ~x64-macos"

RDEPEND="dev-libs/openssl:0="
DEPEND="${RDEPEND}"

distutils_enable_tests unittest
