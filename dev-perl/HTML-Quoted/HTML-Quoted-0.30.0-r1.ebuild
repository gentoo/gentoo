# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-Quoted/HTML-Quoted-0.30.0-r1.ebuild,v 1.1 2014/08/26 17:26:58 axs Exp $

EAPI=5

MODULE_AUTHOR=RUZ
MODULE_VERSION=0.03
inherit perl-module

DESCRIPTION="Extract structure of quoted HTML mail message"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/HTML-Parser-3.0.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.420.0
"

SRC_TEST=do
