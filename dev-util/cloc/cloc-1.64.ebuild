# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cloc/cloc-1.64.ebuild,v 1.1 2015/07/02 09:10:53 tamiko Exp $

EAPI=5

DESCRIPTION="Count Lines of Code"
HOMEPAGE="http://cloc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.pl mirror://sourceforge/${PN}/${PN}.1.pod"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

DEPEND=">=dev-lang/perl-5.6"
RDEPEND="${DEPEND}
	dev-perl/Algorithm-Diff
	dev-perl/regexp-common
	virtual/perl-Digest-MD5
	virtual/perl-Getopt-Long
	virtual/perl-File-Spec
	virtual/perl-File-Temp"

S=${WORKDIR}

src_unpack() { :; }

src_prepare() {
	pod2man "${DISTDIR}"/${PN}.1.pod > ${PN}.1 || die
}

src_install() {
	doman ${PN}.1
	newbin "${DISTDIR}"/${P}.pl ${PN}
}
