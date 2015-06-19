# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-KeePass/File-KeePass-2.30.0.ebuild,v 1.2 2014/12/27 19:52:12 dilfridge Exp $

EAPI=5

MODULE_AUTHOR="RHANDOM"
MODULE_VERSION="2.03"
inherit perl-module

DESCRIPTION="Interface to KeePass V1 and V2 database files"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/Crypt-Rijndael-1
	>=virtual/perl-Digest-SHA-1
	>=virtual/perl-MIME-Base64-1
	dev-perl/XML-Parser
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

SRC_TEST="do"
