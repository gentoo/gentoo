# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/frox/frox-0.7.18-r5.ebuild,v 1.4 2014/01/14 13:56:06 ago Exp $

EAPI=5

inherit autotools eutils user

DESCRIPTION="A transparent ftp proxy"
SRC_URI="http://frox.sourceforge.net/download/${P}.tar.bz2"
HOMEPAGE="http://frox.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

IUSE="clamav ssl transparent"

DEPEND="clamav? ( >=app-antivirus/clamav-0.80 )
	ssl? ( dev-libs/openssl )
	kernel_linux? ( >=sys-kernel/linux-headers-2.6 )"
RDEPEND="${DEPEND}"

# INSTALL has useful filewall rules
DOCS=(
	BUGS README
	doc/CREDITS doc/ChangeLog doc/FAQ doc/INSTALL
	doc/INTERNALS doc/README.transdata doc/RELEASE
	doc/SECURITY doc/TODO
)

pkg_setup() {
	enewgroup ftpproxy
	enewuser ftpproxy -1 -1 /var/spool/frox ftpproxy

	use clamav && ewarn "Virus scanner potentialy broken in chroot - see bug #81035"
}

src_prepare () {
	epatch "${FILESDIR}/${PV}-respect-CFLAGS.patch"
	epatch "${FILESDIR}/${PV}-netfilter-includes.patch"
	epatch "${FILESDIR}/${P}-config.patch"

	if use clamav ; then
		sed -i -e "s:^# VirusScanner.*:# VirusScanner '\"/usr/bin/clamscan\" \"%s\"':" \
			"src/${PN}.conf" || die
	fi

	epatch_user
	eautoreconf
}

src_configure() {
	econf \
		--enable-http-cache --enable-local-cache \
		--enable-procname \
		--enable-configfile=/etc/frox.conf \
		$(use_enable !kernel_linux libiptc) \
		$(use_enable clamav virus-scan) \
		$(use_enable ssl) \
		$(use_enable transparent transparent-data) \
		$(use_enable !transparent ntp)
}

src_install() {
	default

	keepdir /var/{log,spool}/"${PN}"

	fperms 700 /var/spool/frox
	fowners ftpproxy:ftpproxy /var/{log,spool}/frox

	dohtml doc/*.html doc/*.sgml

	newman "doc/${PN}.man" "${PN}.man.8"
	newman "doc/${PN}.conf.man" "${PN}.conf.man.5"

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"

	insinto /etc
	newins "src/${PN}.conf" "${PN}.conf.example"
}
