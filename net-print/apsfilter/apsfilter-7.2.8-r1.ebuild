# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Apsfilter Prints So Fine, It Leads To Extraordinary Results"
HOMEPAGE="http://www.apsfilter.org"
SRC_URI="http://www.apsfilter.org/download/${P}.tar.bz2"
S="${WORKDIR}/${PN}"

KEYWORDS="~alpha ~amd64 ppc sparc x86"
IUSE="cups"
SLOT="0"
LICENSE="GPL-2"

RDEPEND="
	app-text/ghostscript-gpl
	>=app-text/psutils-1.17
	>=app-text/a2ps-4.13b-r4
	net-print/cups
	virtual/awk
	virtual/imagemagick-tools
	virtual/mta"
DEPEND="${RDEPEND}"

src_configure() {
	local myconf=

	# assume that lprng is installed if cups isn't USEd
	if use cups ; then
		myconf="--with-printcap=/etc/cups/printcap --with-spooldir=/var/spool/cups"
	else
		myconf="--with-printcap=/etc/lprng/printcap"
	fi

	# econf doesn't work here :(
	./configure \
		--prefix="${EPREFIX}/usr" \
		--mandir=/usr/share/man \
		--docdir=/usr/share/doc/${PF} \
		--sysconfdir=/etc \
		"${myconf} ${EXTRA_ECONF}" \
	|| die
}

src_install() {
	emake DESTDIR="${ED}" install
	dosym ../share/apsfilter/SETUP /usr/bin/apsfilter

	if use cups ; then
		dosym ../cups/printcap /etc/printcap
	else
		dosym ../lprng/printcap /etc/printcap
	fi
}
