# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=GETTY
MODULE_VERSION=1.22
inherit perl-module

DESCRIPTION="HTTP Body Parser"

SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

# HTTP::Headers -> HTTP-Message
# HTTP::Request::Common -> HTTP-Message
# IO::File -> IO
RDEPEND="
	virtual/perl-Carp
	virtual/perl-Digest-MD5
	>=virtual/perl-File-Temp-0.140.0
	dev-perl/HTTP-Message
	>=virtual/perl-IO-1.140.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Encode
		virtual/perl-File-Spec
		>=virtual/perl-File-Temp-0.140.0
		dev-perl/HTTP-Message
		dev-perl/Test-Deep
		>=virtual/perl-Test-Simple-0.860.0
	)
"
PERL_RM_FILES=(
	t/02pod.t
	t/03podcoverage.t
	t/04critic.t
)
PATCHES=( "${FILESDIR}/${PN}-1.190.0-CVE-2013-4407.patch" )

SRC_TEST=do
