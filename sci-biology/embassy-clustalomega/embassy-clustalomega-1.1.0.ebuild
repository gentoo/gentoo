# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/embassy-clustalomega/embassy-clustalomega-1.1.0.ebuild,v 1.2 2015/03/28 17:56:03 jlec Exp $

EAPI=5

EBO_DESCRIPTION="Clustal Omega - Scalable multiple protein sequences alignment"

AUTOTOOLS_AUTORECONF=1

inherit emboss-r1

KEYWORDS="~amd64 ~x86 ~x86-linux ~ppc-macos"

RDEPEND+=" sci-biology/clustal-omega"

PATCHES=( "${FILESDIR}"/${P}_fix-build-system.patch )
