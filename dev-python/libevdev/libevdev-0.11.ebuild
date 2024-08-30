# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

MY_P=python-libevdev-${PV}
DESCRIPTION="Python wrappers for the libevdev library"
HOMEPAGE="
	https://gitlab.freedesktop.org/libevdev/python-libevdev/
	https://pypi.org/project/libevdev/
"
SRC_URI="
	https://gitlab.freedesktop.org/libevdev/python-libevdev/-/archive/${PV}/${MY_P}.tar.bz2
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

BDEPEND="
	test? (
		dev-libs/libevdev
	)
"
RDEPEND="
	dev-libs/libevdev
"

distutils_enable_tests unittest
distutils_enable_sphinx doc/source \
	dev-python/sphinx-rtd-theme
