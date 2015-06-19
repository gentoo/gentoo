# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/dreampie/dreampie-1.2.1.ebuild,v 1.4 2015/04/08 08:04:57 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="pygtk-based python shell"
HOMEPAGE="http://dreampie.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/pygtksourceview[${PYTHON_USEDEP}]"
DEPEND=""
