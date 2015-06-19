# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/LWP-Authen-Wsse/LWP-Authen-Wsse-0.50.0-r1.ebuild,v 1.1 2014/08/23 01:50:51 axs Exp $

EAPI=5

MODULE_AUTHOR=AUTRIJUS
MODULE_VERSION=0.05
inherit perl-module

DESCRIPTION="Library for enabling X-WSSE authentication in LWP"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="virtual/perl-MIME-Base64
	dev-perl/Digest-SHA1"
DEPEND="${RDEPEND}"

SRC_TEST=do
