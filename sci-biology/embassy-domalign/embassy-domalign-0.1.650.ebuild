# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/embassy-domalign/embassy-domalign-0.1.650.ebuild,v 1.2 2015/03/28 17:58:10 jlec Exp $

EAPI=5

EBO_DESCRIPTION="Protein domain alignment add-on package"

AUTOTOOLS_AUTORECONF=1

inherit emboss-r1

KEYWORDS="~amd64 ~ppc ~x86 ~x86-linux ~ppc-macos"

PATCHES=( "${FILESDIR}"/${P}_fix-build-system.patch )
