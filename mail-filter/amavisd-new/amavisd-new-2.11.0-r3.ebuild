# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit systemd user

MY_P="${P/_/-}"
DESCRIPTION="High-performance interface between the MTA and content checkers"
HOMEPAGE="http://www.ijs.si/software/amavisd/"
SRC_URI="http://www.ijs.si/software/amavisd/${MY_P}.tar.xz"
PORTAGE_DOHTML_WARN_ON_SKIPPED_FILES=yes

LICENSE="GPL-2 BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc64 ~x86"
IUSE="clamav courier dkim ldap mysql postgres qmail razor snmp spamassassin zmq"

DEPEND=">=sys-apps/sed-4
	>=dev-lang/perl-5.10.0"

RDEPEND="${DEPEND}
	>=sys-apps/coreutils-5.0-r3
	app-arch/cpio
	app-arch/gzip
	app-arch/bzip2
	app-arch/arc
	app-arch/cabextract
	app-arch/freeze
	app-arch/lha
	app-arch/lrzip
	app-arch/lzop
	app-arch/ncompress
	app-arch/p7zip
	app-arch/pax
	app-arch/unarj
	app-arch/unrar
	app-arch/xz-utils
	app-arch/zoo
	net-mail/ripole
	>=dev-perl/Archive-Zip-1.14
	>=virtual/perl-IO-Compress-1.35
	>=virtual/perl-Compress-Raw-Zlib-2.017
	net-mail/tnef
	virtual/perl-MIME-Base64
	>=dev-perl/MIME-tools-5.415
	>=dev-perl/MailTools-1.58
	>=dev-perl/Net-Server-0.91
	virtual/perl-Digest-MD5
	dev-perl/IO-stringy
	virtual/perl-IO-Socket-IP
	>=virtual/perl-Time-HiRes-1.49
	dev-perl/Unix-Syslog
	dev-perl/Net-LibIDN
	sys-apps/file
	>=sys-libs/db-4.4.20
	dev-perl/BerkeleyDB
	dev-perl/Convert-BinHex
	>=dev-perl/Mail-DKIM-0.31
	virtual/perl-File-Temp
	dev-perl/Net-SSLeay
	dev-perl/IO-Socket-SSL
	virtual/mta
	clamav? ( app-antivirus/clamav )
	ldap? ( >=dev-perl/perl-ldap-0.33 )
	mysql? ( dev-perl/DBD-mysql )
	postgres? ( dev-perl/DBD-Pg )
	razor? ( mail-filter/razor )
	snmp? ( net-analyzer/net-snmp[perl] )
	spamassassin? ( mail-filter/spamassassin dev-perl/Image-Info )
	zmq? ( dev-perl/ZMQ-LibZMQ3 )"

AMAVIS_ROOT="/var/amavis"
S="${WORKDIR}/${MY_P}"

src_prepare() {
	if use courier ; then
		eapply -p0 amavisd-new-courier.patch
	fi

	if use qmail ; then
		eapply -p0 amavisd-new-qmqpqq.patch
	fi

	sed -i  \
		-e '/daemon/s/vscan/amavis/' \
		-e "s:'/var/virusmails':\"\$MYHOME/quarantine\":" \
		"${S}/amavisd.conf" "${S}/amavis-mc"  || die "missing conf file"

	if ! use dkim ; then
		sed -i -e '/enable_dkim/s/1/0/' "${S}/amavisd.conf" \
			|| die "missing conf file - dkim"
	fi

	if use zmq ; then
		sed -i -e '/enable_zmq/s/# //' "${S}/amavisd.conf" \
			|| die "missing conf file - zmq"
	fi

	if ! use spamassassin ; then
		sed -i -e \
			"/^#[[:space:]]*@bypass_spam_checks_maps[[:space:]]*=[[:space:]]*(1)/s/^#//" \
				"${S}/amavisd.conf" || die "missing conf file - sa"
	fi
	eapply_user
}

src_install() {
	dosbin amavisd amavisd-agent amavisd-nanny amavisd-release \
		amavisd-signer amavisd-status
	dobin p0f-analyzer.pl amavisd-submit

	if use snmp ; then
		dosbin amavisd-snmp-subagent
		use zmq && dosbin amavisd-snmp-subagent-zmq
		dodoc AMAVIS-MIB.txt
		newinitd "${FILESDIR}"/amavisd-snmp.initd amavisd-snmp
	fi

	if use zmq ; then
		dosbin amavis-services amavis-mc
		newinitd "${FILESDIR}"/amavis-mc.initd amavis-mc
	fi

	insinto /etc
	insopts -m0640
	doins amavisd.conf

	newinitd "${FILESDIR}/amavisd.initd-r1" amavisd

	systemd_dounit "${FILESDIR}/amavisd.service"
	use clamav || sed -i -e '/Wants=clamd/d' "${ED}"/usr/lib/systemd/system/amavisd.service
	use spamassassin || sed -i -e '/Wants=spamassassin/d' "${ED}"/usr/lib/systemd/system/amavisd.service

	keepdir "${AMAVIS_ROOT}"
	keepdir "${AMAVIS_ROOT}/db"
	keepdir "${AMAVIS_ROOT}/quarantine"
	keepdir "${AMAVIS_ROOT}/tmp"
	keepdir "${AMAVIS_ROOT}/var"

	dodoc AAAREADME.first INSTALL MANIFEST RELEASE_NOTES TODO \
		amavisd.conf-default amavisd-custom.conf

	docinto README_FILES
	dodoc README_FILES/README*
	dodoc -r README_FILES/*.{html,css}
	docinto README_FILES/images
	dodoc README_FILES/images/*.png
	docinto README_FILES/images/callouts
	dodoc README_FILES/images/callouts/*.png

	docinto test-messages
	dodoc test-messages/README
	dodoc test-messages/sample.tar.gz.compl

	if use ldap ; then
		dodir /etc/openldap/schema
		insinto /etc/openldap/schema
		insopts -o root -g root -m 644
		newins LDAP.schema ${PN}.schema || die
	fi
}

pkg_preinst() {
	enewgroup amavis
	enewuser amavis -1 -1 "${AMAVIS_ROOT}" amavis
	if use razor ; then
		if [ ! -d "${ROOT}${AMAVIS_ROOT}/.razor" ] ; then
			elog "Setting up initial razor config files..."

			razor-admin -create -home="${D}/${AMAVIS_ROOT}/.razor"
			sed -i -e "s:debuglevel\([ ]*\)= .:debuglevel\1= 0:g" \
				"${D}/${AMAVIS_ROOT}/.razor/razor-agent.conf" || die
		fi
	fi
}

pkg_postinst() {
	chown root:amavis "${ROOT}/etc/amavisd.conf"
	chown -R amavis:amavis "${ROOT}/${AMAVIS_ROOT}"
}
