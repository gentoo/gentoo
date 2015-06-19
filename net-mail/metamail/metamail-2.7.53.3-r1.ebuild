# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/metamail/metamail-2.7.53.3-r1.ebuild,v 1.8 2013/02/28 14:08:51 eras Exp $

EAPI=4

WANT_AUTOCONF="2.5"

inherit autotools eutils toolchain-funcs versionator

MY_PV=$(get_version_component_range 1-2)
DEB_PV=${MY_PV}-$(get_version_component_range 3)

DESCRIPTION="Metamail (with Debian patches) - Generic MIME package"
HOMEPAGE="http://ftp.funet.fi/pub/unix/mail/metamail/"
SRC_URI="http://ftp.funet.fi/pub/unix/mail/metamail/mm${MY_PV}.tar.Z
	mirror://debian/pool/main/m/metamail/metamail_${DEB_PV}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"
IUSE="static-libs"

DEPEND="sys-libs/ncurses
	app-arch/sharutils
	net-mail/mailbase"
RDEPEND="app-misc/mime-types
	sys-apps/debianutils
	!app-misc/run-mailcap"

S=${WORKDIR}/mm${MY_PV}/src

src_prepare() {
	epatch "${WORKDIR}"/metamail_${DEB_PV}.diff
	epatch "${FILESDIR}"/${PN}-2.7.45.3-CVE-2006-0709.patch
	epatch "${FILESDIR}"/${P}-glibc-2.10.patch

	# respect CFLAGS
	sed -i -e 's/CFLAGS/LIBS/' \
		"${S}"/src/{metamail,richmail}/Makefile.am || die

	# add missing include - QA
	sed -i -e '/config.h/a #include <string.h>' \
		"${S}"/src/metamail/shared.c || die

	# Fix building with ncurses[tinfo]
	sed -i -e "s/-lncurses/$($(tc-getPKG_CONFIG) --libs ncurses)/" \
		src/richmail/Makefile.am \
		src/metamail/Makefile.am || die
	eautoreconf
	chmod +x "${S}"/configure
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_compile() {
	emake CC=$(tc-getCC) CFLAGS="${CFLAGS}"
}

src_install () {
	emake DESTDIR="${D}" install
	dodoc CREDITS README
	rm man/mmencode.1
	doman man/* debian/mimencode.1 debian/mimeit.1

	use static-libs || find "${D}"/usr/lib* -name '*.la' -delete
}
