# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/glm/glm-0.9.2.4.ebuild,v 1.2 2012/01/14 21:57:46 ssuominen Exp $

EAPI=4

DESCRIPTION="OpenGL Mathematics"
HOMEPAGE="http://glm.g-truc.net/"
SRC_URI="mirror://sourceforge/ogl-math/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="app-arch/unzip"

src_install() {
	dodoc doc/${PN}-0.9.2.pdf
	cd ${PN}
	insinto /usr/include/${PN}
	doins -r *.hpp core gtc gtx virtrev
	rm "${D}"/usr/include/${PN}/core/*cpp
}
