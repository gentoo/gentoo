# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A tool allowing incremental and recursive imap transfer from one mailbox to another"
HOMEPAGE="http://ks.lamiral.info/imapsync/"
SRC_URI="https://fedorahosted.org/released/${PN}/${P}.tgz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}
	dev-perl/Digest-HMAC
	dev-perl/File-Copy-Recursive
	dev-perl/IO-Socket-SSL
	dev-perl/IO-Tee
	dev-perl/Mail-IMAPClient
	dev-perl/TermReadKey
	virtual/perl-Digest-MD5
	virtual/perl-MIME-Base64"

RESTRICT="test"

src_prepare() {
	sed -e "s/^install: testp/install:/" \
		-e "/^DO_IT/,/^$/d" \
		-i "${S}"/Makefile || die
}

src_compile() { :; }
