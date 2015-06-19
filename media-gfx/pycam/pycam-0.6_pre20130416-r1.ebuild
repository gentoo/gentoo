# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/pycam/pycam-0.6_pre20130416-r1.ebuild,v 1.1 2014/01/13 07:31:18 slis Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 python-r1

DESCRIPTION="Open Source CAM - Toolpath Generation for 3-Axis CNC machining"
HOMEPAGE="http://pycam.sourceforge.net/"
SRC_URI="http://dev.gentoo.org/~slis/${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"

DEPEND="
	dev-python/pygtk
	dev-python/pygtkglext
	dev-python/pyopengl
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}/fix-export-toolpath.patch"
	distutils-r1_src_prepare
}
