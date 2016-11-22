# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy )
inherit distutils-r1

DESCRIPTION="A Python module to deal with freedesktop.org specifications"
HOMEPAGE="https://freedesktop.org/wiki/Software/pyxdg https://cgit.freedesktop.org/xdg/pyxdg/"
SRC_URI="https://people.freedesktop.org/~takluyver/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="test"

DEPEND="test? ( dev-python/nose[${PYTHON_USEDEP}]
	x11-themes/hicolor-icon-theme )"

DOCS=( AUTHORS ChangeLog README TODO )
PATCHES=( "${FILESDIR}"/sec-patch-CVE-2014-1624.patch )

python_test() {
	nosetests || die
}
