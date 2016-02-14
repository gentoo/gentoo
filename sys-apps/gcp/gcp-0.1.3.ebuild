# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="File copying utility with progress and I/O indicator"
HOMEPAGE="http://wiki.goffi.org/wiki/Gcp/en"
SRC_URI="ftp://ftp.goffi.org/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/progressbar[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]"

src_prepare() {
	default
	sed -e '/use_setuptools/d' \
	    -e 's#.\+share/doc.\+#],#' -i setup.py || die
}
