# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-RewriteAttributes/HTML-RewriteAttributes-0.50.0-r1.ebuild,v 1.1 2014/08/26 17:27:40 axs Exp $

EAPI=5

MODULE_AUTHOR=TSIBLEY
MODULE_VERSION=0.05
inherit perl-module

DESCRIPTION="Perl module for concise attribute rewriting"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/URI
	dev-perl/HTML-Tagset
	dev-perl/HTML-Parser"
DEPEND="${RDEPEND}"

SRC_TEST="do"
