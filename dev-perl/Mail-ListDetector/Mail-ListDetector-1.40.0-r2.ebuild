# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MSTEVENS
DIST_VERSION=1.04
inherit perl-module

DESCRIPTION="Perl extension for detecting mailing list messages"

SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="
	dev-perl/URI
	dev-perl/Email-Valid
	dev-perl/Email-Abstract
"
BDEPEND="${RDEPEND}"
