# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/apsfilter/apsfilter-7.2.8.ebuild,v 1.2 2013/03/10 01:54:43 ottxor Exp $

EAPI=4

DESCRIPTION="Apsfilter Prints So Fine, It Leads To Extraordinary Results"
HOMEPAGE="http://www.apsfilter.org"
SRC_URI="http://www.apsfilter.org/download/${P}.tar.bz2"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="cups"
SLOT="0"
LICENSE="GPL-2"

RDEPEND="|| ( net-print/cups net-print/lprng )
	app-text/ghostscript-gpl
	>=app-text/psutils-1.17
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] )
	>=app-text/a2ps-4.13b-r4
	virtual/awk
	virtual/mta"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

src_configure() {
	# assume thet lprng is installed if cups isn't USEd
	use cups && \
	    myconf="--with-printcap=/etc/cups/printcap --with-spooldir=/var/spool/cups" || \
	    myconf="--with-printcap=/etc/lprng/printcap"

	# econf doesn't work here :(
	./configure --prefix=/usr --mandir=/usr/share/man \
		--docdir=/usr/share/doc/${PF} --sysconfdir=/etc ${myconf} || die
}

src_install () {
	emake DESTDIR="${D}" install
	dosym /usr/share/apsfilter/SETUP /usr/bin/apsfilter
	use cups && \
	    dosym /etc/cups/printcap /etc/printcap || \
	    dosym /etc/lprng/printcap /etc/printcap
}
