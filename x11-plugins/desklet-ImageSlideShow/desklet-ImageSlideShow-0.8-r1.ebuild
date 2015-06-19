# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/desklet-ImageSlideShow/desklet-ImageSlideShow-0.8-r1.ebuild,v 1.5 2013/06/09 19:06:26 floppym Exp $

EAPI=2
CONTROL_NAME="${PN#desklet-}"

inherit gdesklets

DESCRIPTION="ImageSlideShow Control for gDesklets"
HOMEPAGE="http://gdesklets.de/index.php?q=control/view/211"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="${RDEPEND} virtual/python-imaging"
DOCS="MANIFEST README"

src_prepare() {
	epatch "${FILESDIR}/${CONTROL_NAME}-${PV}-cache-dir.patch"
}
