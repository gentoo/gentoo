# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/embassy-hmmer/embassy-hmmer-2.3.2-r2.ebuild,v 1.5 2011/10/20 08:54:01 xarthisius Exp $

EBOV="6.0.1"

inherit embassy

DESCRIPTION="EMBOSS wrappers for HMMER - Biological sequence analysis with profile HMMs"
SRC_URI="ftp://emboss.open-bio.org/pub/EMBOSS/old/${EBOV}/EMBOSS-${EBOV}.tar.gz
	mirror://gentoo/embassy-${EBOV}-${PN:8}-${PV}.tar.gz"

KEYWORDS="amd64 ~ppc x86"

RDEPEND="~sci-biology/hmmer-2.3.2"

src_install() {
	embassy_src_install
	insinto /usr/include/emboss/hmmer
	doins src/*.h
}
