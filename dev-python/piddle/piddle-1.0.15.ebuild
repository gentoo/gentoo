# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/piddle/piddle-1.0.15.ebuild,v 1.9 2010/07/01 02:48:47 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Cross-media, cross-platform 2D graphics package"
HOMEPAGE="http://piddle.sourceforge.net/"
SRC_URI="mirror://sourceforge/piddle/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ia64 x86"
IUSE=""

src_install() {
	distutils_src_install
	dohtml -r docs/*
}
