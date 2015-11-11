# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

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

	# hacky, but otherwise we only get a symlink in distdir...
	cp -L "${DISTDIR}"/${P}.pl "${WORKDIR}"/

	# fix stuoid perl array error...  again...
	if has_version '>=dev-lang/perl-5.22.0' ; then
		epatch "${FILESDIR}"/${PN}-fix_stupid_perl_array_error_again.patch
	fi
}

src_install() {
	doman ${PN}.1
	newbin "${WORKDIR}"/${P}.pl ${PN}
}
