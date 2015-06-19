# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/bar/bar-1.11.1.ebuild,v 1.4 2011/08/07 17:35:31 armin76 Exp $

EAPI=4

inherit autotools

DESCRIPTION="Console Progress Bar"
HOMEPAGE="http://clpbar.sourceforge.net/"
SRC_URI="mirror://sourceforge/clpbar/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

DEPEND="doc? ( >=app-doc/doxygen-1.3.5 )"
RDEPEND=""

src_prepare() {
	sed -e '/^LDFLAGS/d' \
		-e '/cd $(WEB_DIR) && $(MAKE)/d' -i Makefile.am || die
	eautomake
}

src_configure() {
	local myconf

	# Fix wrt #113392
	use sparc && myconf="${myconf} --disable-use-memalign"
	econf ${myconf}
}

src_compile() {
	emake CFLAGS="${CFLAGS}"
	if use doc; then
		mkdir -p ../www/doxygen/${PV}
		emake update-www
	fi
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS TODO TROUBLESHOOTING debian/changelog
	if use doc ; then
		dohtml -r ../www/doxygen/${PV}/html/*
	fi
}
