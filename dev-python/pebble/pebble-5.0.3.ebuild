# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

MY_P=${P^}
DESCRIPTION="Threading and multiprocessing eye-candy"
HOMEPAGE="
	https://pebble.readthedocs.io/
	https://github.com/noxdafox/pebble/
	https://pypi.org/project/Pebble/
"
SRC_URI="mirror://pypi/${MY_P::1}/${PN^}/${MY_P}.tar.gz"
S=${WORKDIR}/${P^}

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
PATCHES=( "${FILESDIR}/pebble-5.0.3-backport-pr112.patch" )

distutils_enable_tests pytest
