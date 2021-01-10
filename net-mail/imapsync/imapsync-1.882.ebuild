# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Tool for incremental and recursive IMAP transfers between mailboxes"
HOMEPAGE="http://ks.lamiral.info/imapsync/ https://github.com/imapsync/imapsync"
SRC_URI="https://github.com/${PN}/${PN}/archive/${P}.tar.gz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
# ppc dropped pending keywording of:
# dev-perl/App-cpanminus
# dev-perl/Data-Uniqid
# dev-perl/PAR
IUSE="test" # not fully supported yet

RDEPEND="
	dev-perl/App-cpanminus
	dev-perl/Authen-NTLM
	dev-perl/CGI
	dev-perl/Crypt-OpenSSL-RSA
	dev-perl/Data-Uniqid
	dev-perl/Digest-HMAC
	dev-perl/Dist-CheckConflicts
	dev-perl/File-Copy-Recursive
	dev-perl/IO-Socket-INET6
	dev-perl/IO-Socket-SSL
	dev-perl/IO-Tee
	dev-perl/JSON
	dev-perl/libwww-perl
	dev-perl/Mail-IMAPClient
	dev-perl/Module-Implementation
	dev-perl/Module-Runtime
	dev-perl/Module-ScanDeps
	dev-perl/Net-SSLeay
	dev-perl/Package-Stash
	dev-perl/Package-Stash-XS
	dev-perl/PAR
	dev-perl/Parse-RecDescent
	dev-perl/Readonly
	dev-perl/Readonly-XS
	dev-perl/Regexp-Common
	dev-perl/Sys-MemInfo
	dev-perl/TermReadKey
	dev-perl/Try-Tiny
	dev-perl/Unicode-String
	dev-perl/URI
	virtual/perl-Compress-Raw-Zlib
	virtual/perl-Data-Dumper
	virtual/perl-Digest
	virtual/perl-Digest-MD5
	virtual/perl-Digest-SHA
	virtual/perl-Encode
	virtual/perl-MIME-Base64
	"
	# Not yet in tree:
	# HTML::Entities
	# JSON::WebToken
	# JSON::WebToken::Crypt::RSA
DEPEND="
	${RDEPEND}
	test? (
		virtual/perl-Test
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		dev-perl/Test-MockObject
		dev-perl/Test-Pod
		dev-perl/Test-Requires
		dev-perl/Test-Warn
		dev-perl/Test-NoWarnings
	)"
	# Not yet in tree:
	# test? ( Test::Mock::Guard )

RESTRICT="test"

S=${WORKDIR}/${PN}-${P}

src_prepare() {
	sed -e "s/^install: testp/install:/" \
		-e "/^DO_IT/,/^$/d" \
		-i "${S}"/Makefile || die

	default
}

src_compile() { :; }
