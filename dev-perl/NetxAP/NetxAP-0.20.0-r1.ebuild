# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=KJOHNSON
MODULE_VERSION=0.02
inherit perl-module

DESCRIPTION="A base class for protocols such as IMAP, ACAP, IMSP, and ICAP"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/perl-MIME-Base64
	dev-perl/MD5
	virtual/perl-Digest-MD5"
DEPEND="${RDEPEND}"

SRC_TEST=""
