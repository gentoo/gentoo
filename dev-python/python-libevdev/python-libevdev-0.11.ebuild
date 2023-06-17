# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Python wrappers for the libevdev library"
HOMEPAGE="
	https://gitlab.freedesktop.org/libevdev/python-libevdev/
	https://pypi.org/project/libevdev/
"
SRC_URI="
	https://gitlab.freedesktop.org/libevdev/${PN}/-/archive/${PV}/${P}.tar.bz2
"

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
