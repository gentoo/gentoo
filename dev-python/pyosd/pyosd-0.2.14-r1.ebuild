# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyosd/pyosd-0.2.14-r1.ebuild,v 1.1 2015/01/04 07:02:46 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python module for displaying text on your X display, like the 'On Screen Displays' used on TVs"
HOMEPAGE="http://ichi2.net/pyosd/"
SRC_URI="http://ichi2.net/pyosd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
IUSE="doc examples"

DEPEND=">=x11-libs/xosd-2.2.4"
RDEPEND="${DEPEND}"

python_install_all() {
	use doc && local HTML_DOCS=( pyosd.html )
	use examples && local EXAMPLES=( modules/. )

	distutils-r1_python_install_all
}

pkg_postinst() {
	elog "If you want to run the included daemon, you will need to install dev-python/twisted-core."
	elog "Also note that the volume plugin requires media-sound/aumix."
}
