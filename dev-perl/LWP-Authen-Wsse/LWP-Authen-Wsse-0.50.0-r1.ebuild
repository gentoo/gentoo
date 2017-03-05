# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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
