# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=RJBS
DIST_VERSION=1.317
inherit perl-module

DESCRIPTION="Strip the attachments from a mail"

LICENSE="GPL-2+"
# under the same terms as Tony's original module
# Mail::Message::Attachment::Stripper
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Email-Abstract
	>=dev-perl/Email-MIME-1.900.0
	>=dev-perl/Email-MIME-ContentType-1.16.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		dev-perl/Capture-Tiny
		virtual/perl-Data-Dumper
		dev-perl/Email-Simple
		>=virtual/perl-Test-Simple-0.960.0
	)
"
