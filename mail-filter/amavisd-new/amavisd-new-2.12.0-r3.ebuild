# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

DESCRIPTION="High-performance interface between the MTA and content checkers"
HOMEPAGE="https://gitlab.com/amavis/amavis"
SRC_URI="https://gitlab.com/amavis/amavis/-/archive/v${PV}/amavis-v${PV}.tar.bz2"

LICENSE="GPL-2 BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ppc64 sparc ~x86"
IUSE="clamav courier dkim ldap mysql postgres qmail razor rspamd rspamd-https snmp spamassassin zmq"

MY_RSPAMD_DEPEND="dev-perl/HTTP-Message
	dev-perl/JSON
	dev-perl/LWP-UserAgent-Determined"
DEPEND="acct-user/amavis"
RDEPEND="${DEPEND}
	app-arch/arc
	app-arch/bzip2
	app-arch/cabextract
	app-arch/cpio
	app-arch/gzip
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
	dev-lang/perl:*
	dev-perl/Archive-Zip
	dev-perl/BerkeleyDB
	dev-perl/Convert-BinHex
	dev-perl/File-LibMagic
	dev-perl/IO-Socket-SSL
	dev-perl/IO-stringy
	>=dev-perl/Mail-DKIM-0.31
	>=dev-perl/MailTools-1.58
	>=dev-perl/MIME-tools-5.415
	dev-perl/Net-LibIDN
	>=dev-perl/Net-Server-0.91
	dev-perl/Net-SSLeay
	dev-perl/Unix-Syslog
	net-mail/ripole
	net-mail/tnef
	>=sys-apps/coreutils-5.0-r3
	>=sys-libs/db-4.4.20
	virtual/mta
	virtual/perl-Compress-Raw-Zlib
	virtual/perl-Digest-MD5
	virtual/perl-File-Temp
	virtual/perl-IO-Compress
	virtual/perl-IO-Socket-IP
	virtual/perl-MIME-Base64
	virtual/perl-Time-HiRes
	clamav? ( app-antivirus/clamav )
	ldap? ( >=dev-perl/perl-ldap-0.33 )
	mysql? ( dev-perl/DBD-mysql )
	postgres? ( dev-perl/DBD-Pg )
	razor? ( mail-filter/razor )
	rspamd? ( ${MY_RSPAMD_DEPEND} )
	rspamd-https? ( ${MY_RSPAMD_DEPEND}
		dev-perl/LWP-Protocol-https
		dev-perl/Net-SSLeay )
	snmp? ( net-analyzer/net-snmp[perl] )
	spamassassin? ( mail-filter/spamassassin dev-perl/Image-Info )
	zmq? ( dev-perl/ZMQ-LibZMQ3 )"

AMAVIS_ROOT="/var/lib/amavishome"
S="${WORKDIR}/amavis-v${PV}"

src_prepare() {
	if use courier ; then
		eapply -p0 amavisd-new-courier.patch
	fi

	if use qmail ; then
		eapply -p0 amavisd-new-qmqpqq.patch
	fi

	# We need to fix the daemon_user and daemon_group in amavis-mc even
	# though we're going to run it in the foreground, because it calls
	# "drop_priv" unconditionally and will crash if its user/group
	# doesn't exist.
	sed -i	\
		-e '/daemon/s/vscan/amavis/' \
		-e "s:'/var/virusmails':\"\$MYHOME/quarantine\":" \
		"${S}/amavisd.conf" "${S}/amavis-mc" || die "missing conf file"

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
	dosbin amavisd{,-agent,-nanny,-release,-signer,-status}
	dobin p0f-analyzer.pl amavisd-submit

	if use snmp ; then
		dosbin amavisd-snmp-subagent
		newinitd "${FILESDIR}/amavisd-snmp-subagent.initd" \
				 amavisd-snmp-subagent
		dodoc AMAVIS-MIB.txt

		if use zmq ; then
			dosbin amavisd-snmp-subagent-zmq
			newinitd "${FILESDIR}/amavisd-snmp-subagent-zmq.initd" \
					 amavisd-snmp-subagent-zmq
		fi
	fi

	if use zmq ; then
		dosbin amavis-services amavis-mc
		newinitd "${FILESDIR}/amavis-mc.initd-r1" amavis-mc
	fi

	if use ldap ; then
		insinto /etc/openldap/schema
		newins LDAP.schema "${PN}.schema"
	fi

	# The config file should be root:amavis so that the amavis user can
	# read (only) it after dropping privileges. And of course he should
	# own everything in his home directory.
	insinto /etc
	insopts -m0640 -g amavis
	doins amavisd.conf

	# Implementation detail? Keepdir calls dodir under the hood.
	diropts -o amavis -g amavis
	keepdir "${AMAVIS_ROOT}"/{,db,quarantine,tmp,var}

	# BEWARE:
	#
	# Anything below this line is using the mangled insopts/diropts from
	# above!
	#

	newinitd "${FILESDIR}/amavisd.initd-r2" amavisd

	systemd_newunit "${FILESDIR}/amavisd.service-r1" amavisd.service

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
}

pkg_preinst() {
	# TODO: the following is done as root, but should probably be done
	# as the amavis user.
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
	local d="/var/amavis"
	if [ -d ${d} ]; then
		elog "Existing data found. Please make sure to manually copy it to amavis' new"
		elog "home directory by executing the following command as root from a shell:"
		elog
		elog "  cp -a ${d}/* ${d}/.??* ${AMAVIS_ROOT}/ && rm -r ${d}"
		elog
	fi
}
