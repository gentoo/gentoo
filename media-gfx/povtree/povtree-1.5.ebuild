# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/povtree/povtree-1.5.ebuild,v 1.9 2014/04/25 15:10:42 ulm Exp $

S="${WORKDIR}"
MY_P="${PN}${PV}"
DESCRIPTION="Tree generator for POVray based on TOMTREE macro"
HOMEPAGE="http://propro.ru/go/Wshop/povtree/povtree.html"
SRC_URI="http://propro.ru/go/Wshop/povtree/${MY_P}.zip"

# Free for non-commercial use, according to e-mail from authors #446168
LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=virtual/jre-1.3"
DEPEND="app-arch/unzip"

src_install() {
	# wrapper
	dobin "${FILESDIR}"/povtree || die "dobin failed"
	# package
	insinto /usr/lib/povtree
	doins povtree.jar || die "doins failed"
	dodoc TOMTREE-${PV}.inc help.jpg || die "dodoc failed"
}
