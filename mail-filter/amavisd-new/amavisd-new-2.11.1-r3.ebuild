# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit systemd user

DESCRIPTION="High-performance interface between the MTA and content checkers"
HOMEPAGE="https://gitlab.com/amavis/amavis"
SRC_URI="${HOMEPAGE}/-/archive/${P}/amavis-${P}.tar.gz"

LICENSE="GPL-2 BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
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
	dev-perl/File-LibMagic
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
S="${WORKDIR}/amavis-${P}"

pkg_setup() {
	# Create the user beforehand so that we can install the config file
	# (and some directories) with group "amavis" in src_install().
	enewgroup amavis
	enewuser amavis -1 -1 "${AMAVIS_ROOT}" amavis
}

src_prepare() {
	# amavisd-new version 2.11.0 breaks DKIM signing of outbound mail,
	# see https://bugs.gentoo.org/603582
	eapply "${FILESDIR}/amavisd-2.11.0-dkim.patch"

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
	sed -i  \
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
		dodir /etc/openldap/schema
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
