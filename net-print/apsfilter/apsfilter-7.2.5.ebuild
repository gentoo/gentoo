# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/apsfilter/apsfilter-7.2.5.ebuild,v 1.11 2013/03/10 01:54:43 ottxor Exp $

DESCRIPTION="Apsfilter Prints So Fine, It Leads To Extraordinary Results"
HOMEPAGE="http://www.apsfilter.org"
KEYWORDS="x86 ppc alpha sparc"
IUSE="cups"
SLOT="0"
LICENSE="GPL-2"

RDEPEND="|| ( net-print/cups net-print/lprng )
	app-text/ghostscript-gpl
	>=app-text/psutils-1.17
	>=media-gfx/imagemagick-5.4.5
	>=app-text/a2ps-4.13b-r4
	virtual/awk
	virtual/mta"
DEPEND="${RDEPEND}"

SRC_URI="http://www.apsfilter.org/download/${P}.tar.bz2"
S=${WORKDIR}/apsfilter

src_compile() {
	# assume thet lprng is installed if cups isn't USEd
	use cups && \
	    myconf="--with-printcap=/etc/cups/printcap --with-spooldir=/var/spool/cups" || \
	    myconf="--with-printcap=/etc/lprng/printcap"
	./configure --prefix=/usr ${myconf} || die

	emake || die
}

src_install () {
	emake DESTDIR="${D}" install || die
	dosym /usr/share/apsfilter/SETUP /usr/bin/apsfilter
	use cups && \
	    dosym /etc/cups/printcap /etc/printcap || \
	    dosym /etc/lprng/printcap /etc/printcap
}
