# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_P="MiniMock-${PV}"

DESCRIPTION="The simplest possible mock library"
HOMEPAGE="https://pypi.org/project/MiniMock/"
SRC_URI="https://github.com/lowks/minimock/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ppc x86"

DOCS=( CHANGELOG.txt README.rst )

distutils_enable_tests nose

src_prepare() {
	sed -i -e '/cov/d' setup.cfg || die
	default
}
