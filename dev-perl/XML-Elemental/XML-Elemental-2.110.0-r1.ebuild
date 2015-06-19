# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-Elemental/XML-Elemental-2.110.0-r1.ebuild,v 1.1 2014/08/24 02:35:41 axs Exp $

EAPI=5

MODULE_AUTHOR=TIMA
MODULE_VERSION=2.11
inherit perl-module

DESCRIPTION="an XML::Parser style and generic classes for simplistic and perlish handling of XML data"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 hppa ia64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

DEPEND="dev-perl/XML-Parser
	dev-perl/XML-SAX
	dev-perl/Class-Accessor"
RDEPEND="${DEPEND}"

SRC_TEST="do"
