# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=MSTEVENS
MODULE_VERSION=1.04
inherit perl-module

DESCRIPTION="Perl extension for detecting mailing list messages"

SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="dev-perl/URI
	dev-perl/Email-Valid
	dev-perl/Email-Abstract"
DEPEND="${RDEPEND}"

SRC_TEST="do"
