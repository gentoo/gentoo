# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

doc_ver=20080226

DESCRIPTION="XMDS - The eXtensible Multi-Dimensional Simulator"
HOMEPAGE="http://www.xmds.org"
SRC_URI="mirror://sourceforge/xmds/${P}.tar.gz
	 doc? ( mirror://sourceforge/xmds/xmds_doc_${doc_ver}.pdf )"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples mpi threads"

DEPEND="sci-libs/fftw
		mpi? ( virtual/mpi )"

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}"

	epatch "${FILESDIR}"/${PN}-1.6.5-gcc43.patch
	touch "${S}/source/version.h"

	# Fix broken installation of sample scripts.
	sed -i -e 's/install-data-am: install-dist_doc_examplesDATA install-man/install-data-am: install-man/' Makefile.in
}

src_compile() {
	local my_opts=""

	if has_version "=sci-libs/fftw-3*" ; then
		my_opts="${my_opts} --enable-fftw3"
	fi

	econf \
		$(use_enable mpi) \
		$(use_enable threads) \
		${my_opts} || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die

	if use doc; then
		insinto /usr/share/doc/${PF}
		doins "${DISTDIR}/xmds_doc_${doc_ver}.pdf"
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
	fi
}
