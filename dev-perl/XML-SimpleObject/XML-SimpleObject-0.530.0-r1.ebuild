# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-SimpleObject/XML-SimpleObject-0.530.0-r1.ebuild,v 1.1 2014/08/24 02:48:20 axs Exp $

EAPI=5

MODULE_AUTHOR=DBRIAN
MODULE_VERSION=0.53
MY_S=${WORKDIR}/${PN}${MODULE_VERSION}
inherit perl-module

DESCRIPTION="A Perl XML Simple package"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE=""

RDEPEND=">=dev-perl/XML-Parser-2.30
	>=dev-perl/XML-LibXML-1.54"
DEPEND="${RDEPEND}"

SRC_TEST=do
