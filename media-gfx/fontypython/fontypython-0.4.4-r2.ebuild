# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/fontypython/fontypython-0.4.4-r2.ebuild,v 1.1 2015/07/15 05:06:33 idella4 Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 multilib

DESCRIPTION="Font preview application"
HOMEPAGE="http://savannah.nongnu.org/projects/fontypython"
SRC_URI="http://download.savannah.nongnu.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Crashes w/ debug build of wxGTK (#201315)
DEPEND="dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/wxpython:2.8[${PYTHON_USEDEP}]
	x11-libs/wxGTK:2.8[-debug]"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-pillow.patch" )

src_install() {
	distutils-r1_src_install
	doman "${S}"/fontypython.1
}
