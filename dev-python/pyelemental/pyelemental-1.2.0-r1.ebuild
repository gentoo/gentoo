# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyelemental/pyelemental-1.2.0-r1.ebuild,v 1.1 2015/01/02 08:33:17 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python bindings for libelemental (sci-chemistry/gelemental)"
HOMEPAGE="http://freecode.com/projects/gelemental/"
SRC_URI="http://www.kdau.com/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=sci-chemistry/gelemental-1.2.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-gcc-4.7.patch )

python_install_all() {
	use doc && local HTML_DOCS=( docs/html/. )
	distutils-r1_python_install_all
}
