# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/embassy-meme/embassy-meme-4.7.650.ebuild,v 1.2 2015/03/28 18:00:56 jlec Exp $

EAPI=5

EBO_DESCRIPTION="Wrappers for MEME - Multiple Em for Motif Elicitation"

AUTOTOOLS_AUTORECONF=1

inherit emboss-r1

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND+=" sci-biology/meme"

PATCHES=( "${FILESDIR}"/${P}_fix-build-system.patch )
