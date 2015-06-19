# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTTP-Body/HTTP-Body-1.220.0.ebuild,v 1.1 2015/04/02 10:17:13 zlogene Exp $

EAPI=5

MODULE_AUTHOR=GETTY
MODULE_VERSION=1.22
inherit perl-module

DESCRIPTION="HTTP Body Parser"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

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
