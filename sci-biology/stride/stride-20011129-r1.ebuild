# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Protein secondary structure assignment from atomic coordinates"
HOMEPAGE="http://webclu.bio.wzw.tum.de/stride/"
SRC_URI="
	ftp://ftp.ebi.ac.uk/pub/software/unix/${PN}/src/${PN}.tar.gz
	http://dev.gentoo.org/~jlec/distfiles/${PN}-20060723-update.patch.bz2"

SLOT="0"
LICENSE="STRIDE"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

S="${WORKDIR}"

RESTRICT="mirror bindist"

src_prepare() {
	# this patch updates the source to the most recent
	# version which was kindly provided by the author
	epatch \
		"${DISTDIR}/${PN}-20060723-update.patch.bz2" \
		"${FILESDIR}"/${PN}-LDFLAGS.patch

	# fix makefile
	sed -e "/^CC/s|gcc -g|$(tc-getCC) ${CFLAGS}|" -i Makefile || \
		die "Failed to fix Makefile"
}

src_install() {
	dobin ${PN}
}
