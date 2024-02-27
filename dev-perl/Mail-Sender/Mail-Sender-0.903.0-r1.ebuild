# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CAPOEIRAB
DIST_VERSION=0.903
inherit perl-module

DESCRIPTION="Module for sending mails with attachments through an SMTP server"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="minimal"

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
BDEPEND="${RDEPEND}
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
