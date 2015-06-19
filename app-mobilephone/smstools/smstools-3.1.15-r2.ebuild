# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/smstools/smstools-3.1.15-r2.ebuild,v 1.1 2014/05/06 12:18:49 chainsaw Exp $

EAPI=5

inherit systemd toolchain-funcs user eutils

DESCRIPTION="Send and receive short messages through GSM modems"
HOMEPAGE="http://smstools3.kekekasvi.com/"
SRC_URI="http://smstools3.kekekasvi.com/packages/smstools3-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE="stats"

DEPEND=""
RDEPEND="sys-process/procps
	stats? ( >=dev-libs/mm-1.4.0 )"

S="${WORKDIR}/${PN}3"

pkg_setup() {
	enewgroup sms
	enewuser smsd -1 -1 /var/spool/sms sms
}

src_prepare() {
	epatch "${FILESDIR}/${PV}-makefile-whitespace.patch"
	if use stats; then
		sed -i -e "s:CFLAGS += -D NOSTATS:#CFLAGS += -D NOSTATS:" \
			"${S}/src/Makefile" || die
	fi
	echo "CFLAGS += ${CFLAGS}" >> src/Makefile || die
}

src_compile() {
	cd src || die
	emake \
		CC="$(tc-getCC)" \
		LFLAGS="${LDFLAGS}"
}

src_install() {
	dobin src/smsd
	cd scripts || die
	dobin sendsms sms2html sms2unicode unicode2sms
	dobin hex2bin hex2dec email2sms
	dodoc mysmsd smsevent smsresend sms2xml sql_demo \
		smstest.php checkhandler-utf-8 eventhandler-utf-8 \
		forwardsms regular_run
	cd .. || die

	keepdir /var/spool/sms/incoming
	keepdir /var/spool/sms/outgoing
	keepdir /var/spool/sms/checked
	fowners -R smsd:sms /var/spool/sms
	fperms g+s /var/spool/sms/incoming

	newinitd "${FILESDIR}"/smsd.initd3 smsd
	insopts -o smsd -g sms -m0644
	insinto /etc
	newins examples/smsd.conf.easy smsd.conf
	dohtml -r doc

	systemd_dounit "${FILESDIR}"/smsd.service
	systemd_newtmpfilesd "${FILESDIR}"/smsd.tmpfiles smsd.conf
}

pkg_postinst() {
	touch "${ROOT}"/var/log/smsd.log || die
	chown -f smsd:sms "${ROOT}"/var/log/smsd.log
}
