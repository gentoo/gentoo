# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/lcdf-typetools/lcdf-typetools-2.99.ebuild,v 1.1 2013/08/27 16:38:25 aballier Exp $

EAPI=2

DESCRIPTION="Font utilities for eg manipulating OTF"
SRC_URI="http://www.lcdf.org/type/${P}.tar.gz"
HOMEPAGE="http://www.lcdf.org/type/#typetools"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
LICENSE="GPL-2"
IUSE="+kpathsea"

DEPEND="kpathsea? ( virtual/tex-base )"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_with kpathsea)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc NEWS README ONEWS
}
