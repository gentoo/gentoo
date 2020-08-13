# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MIYAGAWA
DIST_VERSION=0.10
inherit perl-module

DESCRIPTION="Find RFC 822 email addresses in plain text"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Email-Valid-0.179.0
	dev-perl/MailTools
"
BDEPEND="${RDEPEND}
	test? (
		virtual/perl-Test-Simple
	)
"
