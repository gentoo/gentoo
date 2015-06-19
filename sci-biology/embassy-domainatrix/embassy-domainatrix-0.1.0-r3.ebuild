# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/embassy-domainatrix/embassy-domainatrix-0.1.0-r3.ebuild,v 1.4 2011/10/20 08:57:09 xarthisius Exp $

EBOV="6.0.1"

inherit embassy

DESCRIPTION="Protein domain analysis add-on package for EMBOSS"
SRC_URI="ftp://emboss.open-bio.org/pub/EMBOSS/old/${EBOV}/EMBOSS-${EBOV}.tar.gz
	mirror://gentoo/embassy-${EBOV}-${PN:8}-${PV}.tar.gz"

KEYWORDS="amd64 ~ppc x86"
