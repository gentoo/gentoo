# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=MARKOV
MODULE_VERSION=2.118
inherit perl-module

DESCRIPTION="Mail folder manager and MUA backend"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/TimeDate
	>=dev-perl/Devel-GlobalDestruction-0.90.0
	dev-perl/Digest-HMAC
	>=virtual/perl-Encode-2.260.0
	>=dev-perl/File-Remove-0.200.0
	>=virtual/perl-File-Spec-0.700.0
	dev-perl/IO-stringy
	virtual/perl-MIME-Base64
	>=dev-perl/MIME-Types-1.4.0
	>=dev-perl/Object-Realize-Later-0.190.0
	>=virtual/perl-Scalar-List-Utils-1.130.0
	>=dev-perl/URI-1.230.0
	>=dev-perl/User-Identity-0.940.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Harness-3.0.0
		>=virtual/perl-Test-Simple-0.470.0
		>=dev-perl/Test-Pod-1.0.0
	)
"

SRC_TEST=do

src_configure() {
	MAILBOX_INSTALL_OPTIONALS=n \
	MAILBOX_RUN_TESTS=y \
	perl-module_src_configure
}
