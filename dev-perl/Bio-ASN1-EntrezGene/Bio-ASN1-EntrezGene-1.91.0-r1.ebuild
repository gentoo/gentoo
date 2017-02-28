# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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
