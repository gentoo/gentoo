# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/lybniz/lybniz-1.3.2.ebuild,v 1.3 2011/03/02 21:20:18 jlec Exp $

EAPI="3"
PYTHON_DEPEND="2"

inherit distutils

DESCRIPTION="A function plotter program written in PyGTK"
HOMEPAGE="http://lybniz2.sourceforge.net/"
SRC_URI="mirror://sourceforge/lybniz2/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pygtk:2"
RDEPEND="${DEPEND}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	sed -i \
		-e 's/Education;/Education;Math;/' \
		${PN}.desktop || die
}
