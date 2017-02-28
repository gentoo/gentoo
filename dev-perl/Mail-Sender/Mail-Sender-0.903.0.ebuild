# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CAPOEIRAB
DIST_VERSION=0.903
inherit perl-module

DESCRIPTION="Module for sending mails with attachments through an SMTP server"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test minimal"

RDEPEND="
	!minimal? (
		dev-perl/Authen-NTLM
		dev-perl/Digest-HMAC
		dev-perl/IO-Socket-SSL
		dev-perl/Mozilla-CA
		dev-perl/Net-SSLeay
	)
	virtual/perl-Carp
	virtual/perl-Encode
	virtual/perl-Exporter
	virtual/perl-IO
	virtual/perl-MIME-Base64
	virtual/perl-Socket
	virtual/perl-Time-Local
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.880.0
	)
"
pkg_postinst() {
	ewarn "dev-perl/Mail-Sender is deprecated by upstream."
	ewarn
	ewarn "You should consider moving away from it and use"
	ewarn "dev-perl/Email-Sender instead"
}
