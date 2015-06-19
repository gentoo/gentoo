# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/szip/szip-2.1.ebuild,v 1.9 2010/07/09 14:01:12 ssuominen Exp $

inherit eutils

DESCRIPTION="Implementation of the extended-Rice lossless compression algorithm"
HOMEPAGE="http://www.hdfgroup.org/doc_resource/SZIP/"
SRC_URI="ftp://ftp.hdfgroup.org/lib-external/${PN}/${PV}/src/${P}.tar.gz"
LICENSE="szip"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"

IUSE=""
DEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc RELEASE.txt HISTORY.txt
	insinto /usr/share/doc/${PF}/
	emake -C examples clean || die
	doins -r examples
}
