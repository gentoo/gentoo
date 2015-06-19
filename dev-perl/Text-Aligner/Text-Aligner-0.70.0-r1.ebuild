# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Text-Aligner/Text-Aligner-0.70.0-r1.ebuild,v 1.1 2014/08/26 16:03:30 axs Exp $

EAPI=5

MODULE_AUTHOR=ANNO
MODULE_VERSION=0.07
inherit perl-module

DESCRIPTION="Used to justify strings to various alignment styles"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/perl-Term-ANSIColor-2.01"
DEPEND="${RDEPEND}"

SRC_TEST="do"
