# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libnut/libnut-661.ebuild,v 1.16 2013/07/28 19:10:38 aballier Exp $

inherit flag-o-matic

DESCRIPTION="Library and tools to create NUT multimedia files"
HOMEPAGE="http://svn.mplayerhq.hu/nut/
	http://wiki.multimedia.cx/index.php?title=NUT
	http://www.nut-container.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""
DEPEND=""
RDEPEND=""

src_install() {
	emake PREFIX="${D}/usr" install || die "make install died"
	dodoc README
	cd "${S}"/nututils
	dobin nutindex nutmerge nutparse
}
