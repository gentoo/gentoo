# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/adiff/adiff-1.4.ebuild,v 1.9 2010/12/28 15:34:09 ranger Exp $

DESCRIPTION="wordwise diff"
HOMEPAGE="http://agriffis.n01se.net/adiff/"
SRC_URI="${HOMEPAGE}/${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND="dev-lang/perl
	!app-arch/atool"
RDEPEND="${DEPEND}
	sys-apps/diffutils"

S=${WORKDIR}

src_unpack() {
	# Nothing to unpack
	:
}

src_compile() {
	pod2man --release=${PV} --center="${HOMEPAGE}" \
		--date="2007-12-11" "${DISTDIR}"/${P} ${PN}.1 || die
}

src_install() {
	newbin "${DISTDIR}"/${P} ${PN}
	doman ${PN}.1
}
