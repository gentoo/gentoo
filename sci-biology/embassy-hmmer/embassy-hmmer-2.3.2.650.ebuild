# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/embassy-hmmer/embassy-hmmer-2.3.2.650.ebuild,v 1.2 2015/03/28 18:02:43 jlec Exp $

EAPI=5

EBO_DESCRIPTION="Wrappers for HMMER - Biological sequence analysis with profile HMMs"

AUTOTOOLS_AUTORECONF=1

inherit emboss-r1

KEYWORDS="~amd64 ~ppc ~x86 ~x86-linux ~ppc-macos"

RDEPEND+="sci-biology/hmmer"

PATCHES=( "${FILESDIR}"/${P}_fix-build-system.patch )
