# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A command line interface to KeePass database files"
HOMEPAGE="http://kpcli.sourceforge.net"
SRC_URI="http://downloads.sourceforge.net/project/kpcli/${P}.pl"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="X"

DEPEND=""
RDEPEND="
	dev-lang/perl
	dev-perl/Clone
	dev-perl/Crypt-Rijndael
	dev-perl/TermReadKey
	dev-perl/Sort-Naturally
	dev-perl/Term-ShellUI
	>=dev-perl/File-KeePass-0.30.0
	virtual/perl-File-Spec
	virtual/perl-Getopt-Long
	virtual/perl-Digest-MD5
	virtual/perl-Digest-SHA
	virtual/perl-Data-Dumper
	virtual/perl-Term-ANSIColor
	virtual/perl-Time-Piece
	virtual/perl-Carp
	X? (
		dev-perl/Capture-Tiny
		dev-perl/Clipboard
	)
"

src_unpack() {
	mkdir "${S}" || die
	cp "${DISTDIR}/${P}.pl" "${S}/${PN}" || die
}

src_compile() { :; }

src_install() {
	dobin kpcli
}
