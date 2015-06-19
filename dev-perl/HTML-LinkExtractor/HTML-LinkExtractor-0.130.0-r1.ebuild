# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-LinkExtractor/HTML-LinkExtractor-0.130.0-r1.ebuild,v 1.1 2014/08/23 02:02:58 axs Exp $

EAPI=5

MODULE_AUTHOR=PODMASTER
MODULE_VERSION=0.13
inherit perl-module

DESCRIPTION="A bare-bones HTML parser, similar to HTML::Parser, but with a couple important distinctions"

SLOT="0"
KEYWORDS="amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="dev-perl/HTML-Parser"
RDEPEND="${DEPEND}
	dev-perl/URI"
