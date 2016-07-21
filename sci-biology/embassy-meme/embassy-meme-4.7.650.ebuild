# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EBO_DESCRIPTION="Wrappers for MEME - Multiple Em for Motif Elicitation"

AUTOTOOLS_AUTORECONF=1

inherit emboss-r1

KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND+=" sci-biology/meme"

PATCHES=( "${FILESDIR}"/${P}_fix-build-system.patch )
