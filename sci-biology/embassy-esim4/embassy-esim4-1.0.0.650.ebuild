# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/embassy-esim4/embassy-esim4-1.0.0.650.ebuild,v 1.2 2015/03/28 18:01:21 jlec Exp $

EAPI=5

EBO_DESCRIPTION="sim4 - Alignment of cDNA and genomic DNA"

AUTOTOOLS_AUTORECONF=1

inherit emboss-r1

KEYWORDS="~amd64 ~ppc ~x86 ~x86-linux ~ppc-macos"

PATCHES=( "${FILESDIR}"/${P}_fix-build-system.patch )
