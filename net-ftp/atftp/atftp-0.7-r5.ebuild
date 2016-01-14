# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools flag-o-matic systemd

DEBIAN_PV="11"
DEBIAN_A="${PN}_${PV}-${DEBIAN_PV}.diff"

DESCRIPTION="Advanced TFTP implementation client/server"
HOMEPAGE="ftp://ftp.mamalinux.com/pub/atftp/"
SRC_URI="ftp://ftp.mamalinux.com/pub/atftp/${P}.tar.gz
	mirror://debian/pool/main/a/${PN}/${DEBIAN_A}.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="selinux tcpd readline pcre"

DEPEND="tcpd? ( sys-apps/tcp-wrappers )
	readline? ( sys-libs/readline:0= )
	pcre? ( dev-libs/libpcre )"
RDEPEND="${DEPEND}
	!net-ftp/netkit-tftp
	!net-ftp/tftp-hpa
	selinux? ( sec-policy/selinux-tftp )"

PATCHES=(
	"${WORKDIR}/${DEBIAN_A}"
	"${FILESDIR}/${P}-pcre.patch"
	"${FILESDIR}/${P}-password.patch"
	"${FILESDIR}/${P}-tests.patch"
	"${FILESDIR}/${P}-glibc24.patch"
	"${FILESDIR}/${P}-blockno.patch"
	"${FILESDIR}/${P}-spaced_filename.patch"
	"${FILESDIR}/${P}-illreply.patch"
	"${FILESDIR}/${P}-CFLAGS.patch"
)

src_prepare() {
	append-cppflags -D_REENTRANT -DRATE_CONTROL
	# fix #561720 by restoring pre-GCC5 inline semantics
	append-cflags -std=gnu89

	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable tcpd libwrap) \
		$(use_enable readline libreadline) \
		$(use_enable pcre libpcre) \
		--enable-mtftp
}

src_install() {
	default

	newinitd "${FILESDIR}"/atftp.init atftp
	newconfd "${FILESDIR}"/atftp.confd atftp

	systemd_dounit "${FILESDIR}"/atftp.service
	systemd_install_serviced "${FILESDIR}"/atftp.service.conf

	dodoc README* BUGS FAQ Changelog INSTALL TODO
	dodoc "${S}"/docs/*

	docinto test
	cd "${S}"/test || die
	dodoc load.sh mtftp.conf pcre_pattern.txt test.sh test_suite.txt
}
