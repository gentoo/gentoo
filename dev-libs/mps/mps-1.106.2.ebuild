# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/mps/mps-1.106.2.ebuild,v 1.5 2013/05/15 04:13:43 patrick Exp $
EAPI=4

DESCRIPTION="Ravenbrook Memory Pool System"

MY_P="${PN}-kit-${PV}"
HOMEPAGE="http://www.ravenbrook.com/project/mps/"
SRC_URI="http://www.ravenbrook.com/project/${PN}/release/${PV}/${MY_P}.tar.gz"

LICENSE="Sleepycat"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}/code

src_prepare() {
	# need to fix CFLAGS, it's still being silly
	sed -i -e 's/-Werror//' gc.gmk
}

src_compile() {
	emake -f lii4gc.gmk
	emake -f lii4gc.gmk mpsplan.a
	emake -f lii4gc.gmk mmdw.a
}

src_install() {
	mkdir -p "${D}"/usr/include/mps
	cp "${S}"/*.h "${D}"/usr/include/mps
	dolib.a "${S}"/lii4gc/ci/*.a
}
