# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1

MY_P="${PN}-${PV/_p/.post}"
DESCRIPTION="Backports and enhancements for the contextlib module"
HOMEPAGE="https://pypi.org/project/contextlib2/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="PSF-2.4 Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

DOCS=( NEWS.rst README.rst )

distutils_enable_tests unittest
