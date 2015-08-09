# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A fast and simple image viewer based on python and GTK+"
HOMEPAGE="http://mirageiv.berlios.de/"
SRC_URI="mirror://berlios/mirageiv/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11
	>=dev-python/pygtk-2.12:2[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	sys-devel/gettext
	!media-plugins/banshee-mirage"

PATCHES=( "${FILESDIR}"/${PN}-0.9.3-stop_cleaning_up.patch )

src_install() {
	distutils-r1_src_install
	local XDOCS="COPYING CHANGELOG README TODO TRANSLATORS"
	local x
	for x in ${XDOCS}; do
		rm -f "${D}"/usr/share/mirage/${x}
	done
}
