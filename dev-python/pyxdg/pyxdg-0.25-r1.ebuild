# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_6} )
inherit distutils-r1

DESCRIPTION="A Python module to deal with freedesktop.org specifications"
HOMEPAGE="https://freedesktop.org/wiki/Software/pyxdg https://cgit.freedesktop.org/xdg/pyxdg/"
SRC_URI="https://people.freedesktop.org/~takluyver/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-python/nose[${PYTHON_USEDEP}]
	x11-themes/hicolor-icon-theme )"

DOCS=( AUTHORS ChangeLog README TODO )
PATCHES=( "${FILESDIR}"/sec-patch-CVE-2014-1624.patch )

python_test() {
	nosetests || die
}
