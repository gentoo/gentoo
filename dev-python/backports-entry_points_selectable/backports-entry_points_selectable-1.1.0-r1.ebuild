# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

MY_P=${P/-/.}
DESCRIPTION="Compatibility shim providing selectable entry points"
HOMEPAGE="
	https://github.com/jaraco/backports.entry_points_selectable/
	https://pypi.org/project/backports.entry-points-selectable/"
SRC_URI="
	https://github.com/jaraco/backports.entry_points_selectable/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
