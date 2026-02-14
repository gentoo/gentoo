# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN=${PN^}
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Threading and multiprocessing eye-candy"
HOMEPAGE="
	https://pebble.readthedocs.io/
	https://github.com/noxdafox/pebble/
	https://pypi.org/project/Pebble/
"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

EPYTEST_PLUGINS=()
EPYTEST_RERUNS=5
distutils_enable_tests pytest
