# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/xmds/xmds-1.6.6.ebuild,v 1.3 2009/12/24 18:46:04 spock Exp $

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
		for i in "${D}"/usr/share/doc/${PN}/examples/* ; do
			doins "$i"
		done
	fi

	rm -rf "${D}/usr/share/doc/${PN}"
}
