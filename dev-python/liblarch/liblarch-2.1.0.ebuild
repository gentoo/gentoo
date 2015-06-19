# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/liblarch/liblarch-2.1.0.ebuild,v 1.2 2015/04/08 08:04:56 mgorny Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Library to handle directed acyclic graphs"
HOMEPAGE="http://live.gnome.org/liblarch"
SRC_URI="http://gtg.fritalk.com/publique/gtg.fritalk.com/${PN}/${PV}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

# This is what should be run if tarball included testsuite
#python_test() {
#	${PYTHON} "${S}"/run-tests
#}
