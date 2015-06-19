# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/c2esp/c2esp-25c.ebuild,v 1.1 2012/07/25 03:27:45 binki Exp $

EAPI=4

inherit eutils toolchain-funcs

MY_P=${PN}${PV}

DESCRIPTION="A cups filter for Kodak ESP printers"
HOMEPAGE="http://cupsdriverkodak.sf.net/"
SRC_URI="mirror://sourceforge/cupsdriverkodak/files/${MY_P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE=""

S=${WORKDIR}/${MY_P}

DEPEND=">=media-libs/jbigkit-2.0-r1
	>=net-print/cups-1.4"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-ldflags-cppflags.patch

	# Remove embedded media-libs/jbigkit
	rm -f *jbig* || die

	# Remove the embedded jbig files from the Makefile's dependencies:
	sed -i \
		-e '/^[a-z0-9.]*:/s/\$(LIBJBG[[:digit:]]*)//g' \
		-e '/^[a-z0-9.]*:/s/jbig[^ ]*\.h//g' \
		-e '/\$(INSTALL).*COPYING/d' \
		Makefile || die

	# Use Gentoo-style cups paths
	sed -i -e s,/usr/lib/cups/filter,/usr/libexec/cups/filter,g ppd/*.ppd || die
}

src_compile() {
	emake CC="$(tc-getCC)" LIBJBG=-ljbig LIBJBG85=-ljbig85
}

src_install() {
	emake \
		DESTDIR="${D}" \
		FILTERBIN="${D}"/usr/libexec/cups/filter \
		DOCDIR="${ED}"/usr/share/doc/${PF} \
		install
}
