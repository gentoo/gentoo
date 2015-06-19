# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/cimg/cimg-1.5.2.ebuild,v 1.2 2012/12/09 12:18:41 hwoarang Exp $

EAPI=5
MY_P="CImg-${PV}"

DESCRIPTION="C++ template image processing toolkit"
HOMEPAGE="http://cimg.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

LICENSE="CeCILL-2 CeCILL-C"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="app-arch/unzip"

S=${WORKDIR}/${MY_P}

src_install() {
	dodoc README.txt
	doheader CImg.h
	use doc && dohtml -r html/
}
