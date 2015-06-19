# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/libtabe/libtabe-0.2.6.1.2.ebuild,v 1.4 2012/06/14 09:15:59 ago Exp $

WANT_AUTOMAKE=1.11

inherit eutils libtool autotools multilib versionator

DEBIAN_PV=$(replace_version_separator 3 '-')
DEBIAN_PATCH=${PN}_${DEBIAN_PV}.diff
ORIG_PV=${DEBIAN_PV%-*}
ORIG_P=${PN}-${ORIG_PV}

DESCRIPTION="Libtabe provides bimsphone support for xcin-2.5+"
HOMEPAGE="http://packages.qa.debian.org/libt/libtabe.html"
SRC_URI="mirror://debian/pool/main/${PN:0:4}/${PN}/${PN}_${ORIG_PV}.orig.tar.gz
	mirror://debian/pool/main/${PN:0:4}/libtabe/${DEBIAN_PATCH}.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="debug"

DEPEND=">=sys-libs/db-4.5
	x11-libs/libX11"

S=${WORKDIR}/${ORIG_P}.orig

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/${DEBIAN_PATCH}
	epatch "${FILESDIR}"/${ORIG_P}-fabs.patch
	epatch "${FILESDIR}"/${ORIG_P}-ldflags.patch

	ln -s script/configure.in . || die
	eautoreconf
}

src_compile() {
	myconf="--with-db-inc=/usr/include
		--with-db-lib=/usr/$(get_libdir)
		--with-db-bin=/usr/bin
		--with-db-name=db
		--enable-shared
		--disable-static
		$(use_enable debug)"

	econf ${myconf}

	# We execute this serially because the Makefiles don't handle
	# proper cross-directory references.
	for dir in src util tsi-src; do
		emake -C ${dir} || die "make failed"
	done
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc doc/* || die
}
