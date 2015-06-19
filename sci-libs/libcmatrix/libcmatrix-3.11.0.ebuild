# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libcmatrix/libcmatrix-3.11.0.ebuild,v 1.8 2015/01/29 21:31:07 mgorny Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

MY_P="${PN}${PV}_lite"

DESCRIPTION="lite version of pNMRsim"
HOMEPAGE="http://www.dur.ac.uk/paul.hodgkinson/pNMRsim/"
#SRC_URI="${HOMEPAGE}/${MY_P}.tar.gz"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cpu_flags_x86_sse threads"

RDEPEND="sci-libs/minuit"
DEPEND="${RDEPEND}"

RESTRICT=mirror

S="${WORKDIR}"/${PN}R3

PATCHES=(
	"${FILESDIR}"/${PV}-shared.patch
	"${FILESDIR}"/3.2.1-minuit2.patch
	"${FILESDIR}"/3.2.1-gcc4.4.patch
	"${FILESDIR}"/3.2.1-gcc4.6.patch
	"${FILESDIR}"/3.2.1-gcc4.7.patch
	"${FILESDIR}"/3.9.0-atlas.patch
	)

AUTOTOOLS_IN_SOURCE_BUILD=1

src_configure() {
	econf \
		--with-minuit \
		--without-atlas \
		--with-sysroot="${EROOT}" \
		$(use_with cpu_flags_x86_sse sse) \
		$(use_with threads)
}

src_install() {
	dolib.so lib/*.so*

	insinto /usr/include/${PN}R3
	doins include/*

	dodoc CHANGES docs/*
}
