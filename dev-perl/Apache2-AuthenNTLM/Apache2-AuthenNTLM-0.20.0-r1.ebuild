# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Apache2-AuthenNTLM/Apache2-AuthenNTLM-0.20.0-r1.ebuild,v 1.1 2014/08/25 02:18:32 axs Exp $

EAPI=5

MODULE_AUTHOR=SPEEVES
MODULE_VERSION=0.02
inherit perl-module

DESCRIPTION="Apache2::AuthenNTLM - Perform Microsoft NTLM and Basic User Authentication"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="virtual/perl-MIME-Base64
	>=www-apache/mod_perl-2"
DEPEND="${RDEPEND}"
