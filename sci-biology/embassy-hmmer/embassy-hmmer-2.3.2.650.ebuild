# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EBO_DESCRIPTION="Wrappers for HMMER - Biological sequence analysis with profile HMMs"

AUTOTOOLS_AUTORECONF=1

inherit emboss-r1

KEYWORDS="~amd64 ~ppc ~x86 ~x86-linux ~ppc-macos"

RDEPEND+="sci-biology/hmmer"

PATCHES=( "${FILESDIR}"/${P}_fix-build-system.patch )
