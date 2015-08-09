# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils

DESCRIPTION="Inference of RNA alignments"
HOMEPAGE="http://infernal.janelia.org/"
SRC_URI="ftp://selab.janelia.org/pub/software/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE="mpi"
KEYWORDS="amd64 x86"

DEPEND="mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-parallel-build.patch \
		"${FILESDIR}"/${P}-overflows.patch \
		"${FILESDIR}"/${P}-perl-5.16-2.patch \
		"${FILESDIR}"/${P}-ldflags.patch
}

src_configure() {
	econf \
		--prefix="${D}/usr" \
		$(use_enable mpi)
}

src_install() {
	default

	pushd documentation/manpages > /dev/null
	for i in *;
		do newman ${i} ${i/.man/.1}
	done
	popd > /dev/null

	insinto /usr/share/${PN}
	doins -r benchmarks tutorial intro matrices
	dodoc 00README* Userguide.pdf documentation/release-notes/*
}
