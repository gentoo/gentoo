# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Python wrappers for the libevdev library"
HOMEPAGE="https://gitlab.freedesktop.org/libevdev/python-libevdev"
SRC_URI="https://gitlab.freedesktop.org/libevdev/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"

BDEPEND="test? ( dev-libs/libevdev )"
PDEPEND="dev-libs/libevdev"

distutils_enable_tests unittest
distutils_enable_sphinx doc/source \
	dev-python/sphinx_rtd_theme
