# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Bio-ASN1-EntrezGene/Bio-ASN1-EntrezGene-1.91.0-r1.ebuild,v 1.1 2014/08/24 02:53:40 axs Exp $

EAPI=5

MODULE_AUTHOR=MINGYILIU
MODULE_VERSION=1.091
MODULE_A_EXT=tgz
inherit perl-module

DESCRIPTION="Regular expression-based Perl Parser for NCBI Entrez Gene"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

DEPEND=">=sci-biology/bioperl-1.6.0"
RDEPEND="${DEPEND}"

SRC_TEST="do"
S="${WORKDIR}/${PN}-1.09"
