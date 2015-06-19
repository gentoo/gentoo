# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Mail-Box/Mail-Box-2.109.0-r1.ebuild,v 1.1 2014/08/24 02:12:06 axs Exp $

EAPI=5

MODULE_AUTHOR=MARKOV
MODULE_VERSION=2.109
inherit perl-module

DESCRIPTION="Mail folder manager and MUA backend"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	dev-perl/TimeDate
	>=dev-perl/User-Identity-0.930.0
	>=dev-perl/URI-1.230.0
	>=dev-perl/File-Remove-0.200.0
	dev-perl/MailTools
	>=virtual/perl-Encode-2.260.0
	dev-perl/Digest-HMAC
	>=dev-perl/Object-Realize-Later-0.140.0
	dev-perl/IO-stringy
	>=virtual/perl-Scalar-List-Utils-1.130.0
	>=dev-perl/MIME-Types-1.4.0
	virtual/perl-MIME-Base64
	>=virtual/perl-File-Spec-0.700.0
	dev-perl/MIME-tools
	dev-perl/Email-Simple
"
DEPEND="${RDEPEND}
	dev-perl/Devel-GlobalDestruction
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Harness-3.0.0
		>=dev-perl/Test-Pod-1.0.0
	)
"

SRC_TEST=do

src_configure() {
	MAILBOX_INSTALL_OPTIONALS=n \
	MAILBOX_RUN_TESTS=y \
	perl-module_src_configure
}
