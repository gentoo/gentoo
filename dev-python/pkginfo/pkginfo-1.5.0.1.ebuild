# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 python3_{6,7,8,9} pypy3 )

inherit distutils-r1

DESCRIPTION="Provides an API for querying the distutils metadata written in a PKG-INFO file"
HOMEPAGE="https://pypi.org/project/pkginfo/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~sparc x86"
IUSE="doc"

distutils_enable_tests nose
distutils_enable_sphinx docs

src_prepare() {
	# TODO
	sed -i -e 's:test_ctor_w_package_no_PKG_INFO:_&:' \
		pkginfo/tests/test_installed.py || die
	distutils-r1_src_prepare
}
