# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python module for displaying text on your X display, like the 'On Screen Displays' used on TVs"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://ichi2.net/pyosd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc x86"
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
