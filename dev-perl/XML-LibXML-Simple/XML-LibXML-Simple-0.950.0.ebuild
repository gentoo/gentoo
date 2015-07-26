# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-LibXML-Simple/XML-LibXML-Simple-0.950.0.ebuild,v 1.2 2015/07/20 20:34:36 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=MARKOV
MODULE_VERSION=0.95
inherit perl-module

DESCRIPTION="XML::LibXML based XML::Simple clone"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/File-Slurp-Tiny
	>=dev-perl/XML-LibXML-1.640.0
"
DEPEND="${RDEPEND}
"

SRC_TEST=do
