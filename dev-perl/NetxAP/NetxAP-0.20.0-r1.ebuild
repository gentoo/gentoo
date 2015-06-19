# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/NetxAP/NetxAP-0.20.0-r1.ebuild,v 1.1 2014/08/26 17:30:05 axs Exp $

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
