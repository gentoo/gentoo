# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Text-Markdown/Text-Markdown-1.0.31-r1.ebuild,v 1.1 2013/09/14 14:18:22 idella4 Exp $

EAPI=5

MODULE_AUTHOR=BOBTFISH
MODULE_VERSION=1.000031
inherit perl-module

DESCRIPTION="Convert MultiMarkdown syntax to (X)HTML"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="virtual/perl-Digest-MD5
	virtual/perl-Getopt-Long
	virtual/perl-Text-Balanced"

DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple
		dev-perl/Text-Diff
		dev-perl/List-MoreUtils
		dev-perl/Test-Differences
		dev-perl/Test-Exception )"
SRC_TEST=do
mydoc="Readme.text"
