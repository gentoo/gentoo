# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/datadraw/datadraw-3.1.1.ebuild,v 1.2 2012/05/25 15:45:07 mr_bones_ Exp $

EAPI=4

inherit multilib toolchain-funcs

DESCRIPTION="feature rich database generator for high performance C applications"
HOMEPAGE="http://datadraw.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PN}${PV}/${PN}${PV}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

DEPEND=""
RDEPEND=""

S=${WORKDIR}/${PN}${PV}

src_prepare() {
	tc-export CC
	sed -e "/^CFLAGS=/s:-g -Wall:${CFLAGS}:" \
		-i configure \
		-i dataview/configure \
		-i util/configure || die

	sed -e '/^datadraw:/,+2s:\\$(CFLAGS):\\$(CFLAGS) \\$(LDFLAGS):' \
		-i configure || die
}

src_install() {
	dobin ${PN}

	insinto /usr/$(get_libdir)
	for lib in util/*.a ; do
		newins ${lib} lib$(basename ${lib})
	done
	insinto /usr/include

	doins util/*.h

	dodoc README
	if use doc ; then
		dodoc manual.pdf
		dohtml -r www/index.html www/images
	fi
	use examples && dodoc -r examples
}
