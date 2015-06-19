# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/glm/glm-0.9.5.1.ebuild,v 1.2 2014/10/10 20:20:11 maekke Exp $

EAPI=5

DESCRIPTION="OpenGL Mathematics"
HOMEPAGE="http://glm.g-truc.net/"
SRC_URI="mirror://sourceforge/ogl-math/${P}.zip"

S="${WORKDIR}/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND=""
DEPEND="app-arch/unzip"

src_install() {
	dodoc doc/${PN}.pdf
	cd ${PN}
	insinto /usr/include/${PN}
	doins -r *.hpp detail gtc gtx virtrev
	rm "${D}"/usr/include/${PN}/detail/*cpp
}
