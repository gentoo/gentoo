# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DBROBINS
MODULE_VERSION=0.10
inherit perl-module

DESCRIPTION="Secure File Transfer Protocol client"

SLOT="0"
KEYWORDS="amd64 ~mips x86"
IUSE=""

RDEPEND=">=dev-perl/Net-SSH-Perl-1.25"
