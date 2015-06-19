# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-Filter-DOMFilter-LibXML/XML-Filter-DOMFilter-LibXML-0.20.0-r1.ebuild,v 1.1 2014/08/24 02:46:22 axs Exp $

EAPI=5

MODULE_AUTHOR=PAJAS
MODULE_VERSION=0.02
inherit perl-module

DESCRIPTION="SAX Filter allowing DOM processing of selected subtrees"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 hppa ia64 sparc x86"
IUSE=""

RDEPEND=">=dev-perl/XML-LibXML-1.53"
DEPEND="${RDEPEND}"

SRC_TEST="do"
