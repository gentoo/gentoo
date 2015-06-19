# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/piddle/piddle-1.0.15-r1.ebuild,v 1.1 2014/12/31 06:21:35 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Cross-media, cross-platform 2D graphics package"
HOMEPAGE="http://piddle.sourceforge.net/"
SRC_URI="mirror://sourceforge/piddle/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE="doc"

python_install_all() {
	use doc && local HTML_DOCS=( docs/. )
	distutils-r1_python_install_all
}
