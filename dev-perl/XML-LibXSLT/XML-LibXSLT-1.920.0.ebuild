# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-LibXSLT/XML-LibXSLT-1.920.0.ebuild,v 1.1 2015/01/09 00:26:35 zlogene Exp $

EAPI=5

MODULE_AUTHOR=SHLOMIF
MODULE_VERSION=1.92
inherit perl-module

DESCRIPTION="A Perl module to parse XSL Transformational sheets using gnome's libXSLT"

SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND="
	>=dev-libs/libxslt-1.1.28
	>=dev-perl/XML-LibXML-1.700.0
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

SRC_TEST="do"
