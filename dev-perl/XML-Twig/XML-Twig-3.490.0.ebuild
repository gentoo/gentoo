# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=MIROD
MODULE_VERSION=3.49
inherit perl-module

DESCRIPTION="Process huge XML documents in tree mode"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="nls"

RDEPEND="
	>=dev-perl/XML-Parser-2.31
	virtual/perl-Scalar-List-Utils
	>=dev-libs/expat-1.95.5
	dev-perl/Tie-IxHash
	dev-perl/XML-SAX-Writer
	dev-perl/XML-Handler-YAWriter
	dev-perl/XML-XPath
	dev-perl/libwww-perl
	nls? (
		>=dev-perl/Text-Iconv-1.2-r1
	)
"
DEPEND="${RDEPEND}"

SRC_TEST="do"
