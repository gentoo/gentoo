# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic systemd

DEBIAN_PV="11"
DEBIAN_A="${PN}_${PV}-${DEBIAN_PV}.diff.gz"

DESCRIPTION="Advanced TFTP implementation client/server"
HOMEPAGE="ftp://ftp.mamalinux.com/pub/atftp/"
SRC_URI="ftp://ftp.mamalinux.com/pub/atftp/${P}.tar.gz
	mirror://debian/pool/main/a/${PN}/${DEBIAN_A}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 ~s390 sparc x86"
IUSE="selinux tcpd readline pcre"

DEPEND="tcpd? ( sys-apps/tcp-wrappers )
	readline? ( sys-libs/readline )
	pcre? ( dev-libs/libpcre )"
RDEPEND="${DEPEND}
	!net-ftp/netkit-tftp
	!net-ftp/tftp-hpa
	selinux? ( sec-policy/selinux-tftp )"

src_prepare() {
	epatch "${DISTDIR}"/${DEBIAN_A}
	epatch "${FILESDIR}"/${P}-pcre.patch
	epatch "${FILESDIR}"/${P}-password.patch
	epatch "${FILESDIR}"/${P}-tests.patch
	epatch "${FILESDIR}"/${P}-glibc24.patch
	epatch "${FILESDIR}"/${P}-blockno.patch
	epatch "${FILESDIR}"/${P}-spaced_filename.patch
	epatch "${FILESDIR}"/${P}-illreply.patch
	# remove upstream's broken CFLAGS
	sed -i.orig -e \
	  '/^CFLAGS="-g -Wall -D_REENTRANT"/s,".*","",g' \
	  "${S}"/configure
}

src_configure() {
	append-flags -D_REENTRANT -DRATE_CONTROL
	econf \
		$(use_enable tcpd libwrap) \
		$(use_enable readline libreadline) \
		$(use_enable pcre libpcre) \
		--enable-mtftp
}

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	emake install DESTDIR="${D}"

	newinitd "${FILESDIR}"/atftp.init atftp
	newconfd "${FILESDIR}"/atftp.confd atftp

	systemd_dounit "${FILESDIR}"/atftp.service
	systemd_install_serviced "${FILESDIR}"/atftp.service.conf

	dodoc README* BUGS FAQ Changelog INSTALL TODO
	dodoc "${S}"/docs/*

	docinto test
	cd "${S}"/test
	dodoc load.sh mtftp.conf pcre_pattern.txt test.sh test_suite.txt
}
