# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Crypt-Simple/Crypt-Simple-0.60.0-r1.ebuild,v 1.1 2014/08/22 21:23:11 axs Exp $

EAPI=5

MODULE_AUTHOR=KASEI
MODULE_VERSION=0.06
inherit perl-module

DESCRIPTION="Crypt::Simple - encrypt stuff simply"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="dev-perl/FreezeThaw
	virtual/perl-IO-Compress
	dev-perl/Crypt-Blowfish
	virtual/perl-Digest-MD5
	virtual/perl-MIME-Base64"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Harness )"

SRC_TEST="do"
