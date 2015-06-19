# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Apache-AuthCookie/Apache-AuthCookie-3.180.0-r1.ebuild,v 1.1 2014/08/25 02:17:39 axs Exp $

EAPI=5

MODULE_AUTHOR=MSCHOUT
MODULE_VERSION=3.18
inherit perl-module

DESCRIPTION="Perl Authentication and Authorization via cookies"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=www-apache/mod_perl-2
	>=dev-perl/Apache-Test-1.32"
DEPEND="${RDEPEND}"
