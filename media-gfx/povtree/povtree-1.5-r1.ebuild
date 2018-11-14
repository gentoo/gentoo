# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

S="${WORKDIR}"
MY_P="${PN}${PV}"
DESCRIPTION="Tree generator for POVray based on TOMTREE macro"
HOMEPAGE="http://propro.ru/go/Wshop/povtree/povtree.html"
SRC_URI="http://propro.ru/go/Wshop/povtree/${MY_P}.zip"

# Free for non-commercial use, according to e-mail from authors #446168
LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

RDEPEND=">=virtual/jre-1.3"
DEPEND="app-arch/unzip"

src_install() {
	# wrapper
	sed "s:/usr/:${EPREFIX}&:" "${FILESDIR}"/povtree > "${T}"/povtree || die
	dobin "${T}"/povtree
	# package
	insinto /usr/lib/povtree
	doins povtree.jar
	dodoc TOMTREE-${PV}.inc help.jpg
}
