# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/frox/frox-0.7.18-r4.ebuild,v 1.5 2013/06/17 14:41:03 pinkbyte Exp $

EAPI=4
inherit eutils autotools user

IUSE="clamav ssl transparent"

MY_P=${P/_/}
S=${WORKDIR}/${MY_P}

DESCRIPTION="A transparent ftp proxy"
SRC_URI="http://frox.sourceforge.net/download/${MY_P}.tar.bz2"
HOMEPAGE="http://frox.sourceforge.net/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc x86"

DEPEND="clamav? ( >=app-antivirus/clamav-0.80 )
	ssl? ( dev-libs/openssl )
	kernel_linux? ( >=sys-kernel/linux-headers-2.6 )"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup ftpproxy
	enewuser ftpproxy -1 -1 /var/spool/frox ftpproxy

	use clamav && ewarn "Virus scanner potentialy broken in chroot - see bug #81035"
}

src_prepare () {
	epatch "${FILESDIR}"/${PV}-respect-CFLAGS.patch
	epatch "${FILESDIR}"/${PV}-netfilter-includes.patch

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
	emake DESTDIR="${D}" install

	keepdir /var/run/frox
	keepdir /var/spool/frox
	keepdir /var/log/frox

	fperms 700 /var/spool/frox
	fowners ftpproxy:ftpproxy /var/run/frox /var/spool/frox /var/log/frox

	# INSTALL has useful filewall rules
	dodoc BUGS README \
		doc/CREDITS doc/ChangeLog doc/FAQ doc/INSTALL \
		doc/INTERNALS doc/README.transdata doc/RELEASE \
		doc/SECURITY doc/TODO

	dohtml doc/*.html doc/*.sgml

	mv doc/frox.man doc/frox.man.8
	mv doc/frox.conf.man doc/frox.conf.man.8
	doman doc/frox.man.8 doc/frox.conf.man.8

	newinitd "${FILESDIR}"/frox.rc frox

	cd src
	epatch "${FILESDIR}/config-${PV}.patch"

	cp frox.conf "${D}/etc/frox.conf.example"
	if use clamav ; then
		sed -i \
		  -e "s:^# VirusScanner.*:# VirusScanner '\"/usr/bin/clamscan\" \"%s\"':" \
			"${D}/etc/frox.conf.example" || die
	fi
}
