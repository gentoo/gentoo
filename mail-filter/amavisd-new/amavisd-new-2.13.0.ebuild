# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd perl-module

DESCRIPTION="High-performance interface between the MTA and content checkers"
HOMEPAGE="https://gitlab.com/amavis/amavis"
SRC_URI="https://gitlab.com/amavis/amavis/-/archive/v${PV}/amavis-v${PV}.tar.bz2"

LICENSE="GPL-2 BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="clamav dkim ldap mysql postgres razor rspamd rspamd-https selinux snmp spamassassin test"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( spamassassin )"

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
	app-arch/p7zip
	app-arch/pax
	app-arch/arj
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
	dev-perl/Net-LibIDN2
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
	selinux? ( sec-policy/selinux-amavis )
	snmp? ( net-analyzer/net-snmp[perl] )
	spamassassin? ( mail-filter/spamassassin dev-perl/Image-Info )"

BDEPEND="${RDEPEND}
	dev-perl/Dist-Zilla
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Harness
		dev-perl/Test-Class
		dev-perl/DBI
		dev-perl/perl-ldap
		dev-perl/NetAddr-IP
		dev-perl/Test-Most
	)"

AMAVIS_ROOT="/var/lib/amavishome"
S="${WORKDIR}/amavis-v${PV}"

dzil_to_distdir() {
	local dzil_root dest has_missing modname dzil_version
	dzil_root="$1"
	dest="$2"

	cd "${dzil_root}" || die "Can't enter workdir '${dzil_root}'";

	dzil_version="$(dzil version)" || die "Error invoking 'dzil version'"
	einfo "Generating CPAN dist with ${dzil_version}"

	has_missing=""

	einfo "Checking dzil authordeps"
	while IFS= read -d $'\n' -r modname; do
		if [[ -z "${has_missing}" ]]; then
			has_missing=1
			eerror "'dzil authordeps' indicates missing build dependencies"
			eerror "These will prevent building, please report a bug"
			eerror "Missing:"
		fi
	S=	eerror "  ${modname}"
	done < <( dzil authordeps --missing --versions )

	[[ -z "${has_missing}" ]] || die "Satisfy all missing authordeps first"

	einfo "Checking dzil build deps"
	while IFS= read -d $'\n' -r modname; do
		if [[ -z "${has_missing}" ]]; then
			has_missing=1
			ewarn "'dzil listdeps' indicates missing build dependencies"
			ewarn "These may prevent building, please report a bug if they do"
			ewarn "Missing:"
		fi
		ewarn "  ${modname}"
	done < <( dzil listdeps --missing --versions --author )

	einfo "Generating release"
	dzil build --notgz --in "${dest}" || die "Unable to build CPAN dist in '${dest}'"
}

src_prepare() {
	# perl-module doesn't account for this being a directory
	mv README_FILES READ_FILES || die

	# We need to fix the daemon_user and daemon_group in amavis-mc even
	# though we're going to run it in the foreground, because it calls
	# "drop_priv" unconditionally and will crash if its user/group
	# doesn't exist.
	sed -i	\
		-e '/daemon/s/vscan/amavis/' \
		-e "s:'/var/virusmails':\"\$MYHOME/quarantine\":" \
		"${S}/conf/amavisd.conf" "${S}/bin/amavis-mc" || die "missing conf file"

	if ! use dkim ; then
		sed -i -e '/enable_dkim/s/1/0/' "${S}/conf/amavisd.conf" \
			|| die "missing conf file - dkim"
	fi

	if ! use spamassassin ; then
		sed -i -e \
			"/^#[[:space:]]*@bypass_spam_checks_maps[[:space:]]*=[[:space:]]*(1)/s/^#//" \
			"${S}/conf/amavisd.conf" || die "missing conf file - sa"
	fi

	# needs ZMQ::LibZMQ3 which only suports net-libs/zeromq-3*,
	# long since removed from tree
	perl_rm_files t/Amavis/ZMQTest.t
	sed -e '/^ZMQ::LibZMQ3 =/d' \
	-i dist.ini || die "Can't patch dist.ini"

	rm bin/{amavis-services,amavis-mc,amavisd-snmp-subagent-zmq}

	if ! use snmp ; then
		rm bin/amavisd-snmp-subagent
	fi

	eapply_user

	# prevent distdir-in-distdir
	mv "${S}" "${T}" || die
	dzil_to_distdir "${T}/amavis-v${PV}" "${S}"

	perl-module_src_prepare
}

src_test() {
	prove -lr t || die
}

src_install() {
	perl-module_src_install
	mkdir "${ED}"/usr/sbin
	mv "${ED}"/usr/bin/amavisd "${ED}"/usr/sbin/amavisd || die
	mv "${ED}"/usr/bin/amavisd-agent "${ED}"/usr/sbin/amavisd-agent || die
	mv "${ED}"/usr/bin/amavisd-nanny "${ED}"/usr/sbin/amavisd-nanny || die
	mv "${ED}"/usr/bin/amavisd-release "${ED}"/usr/sbin/amavisd-release || die
	mv "${ED}"/usr/bin/amavisd-signer "${ED}"/usr/sbin/amavisd-signer || die
	mv "${ED}"/usr/bin/amavisd-status "${ED}"/usr/sbin/amavisd-status || die
	dobin contrib/p0f-analyzer.pl

	if use snmp ; then
		mv "${ED}"/usr/bin/amavisd-snmp-subagent "${ED}"/usr/sbin/amavisd-snmp-subagent || die
		newinitd "${FILESDIR}/amavisd-snmp-subagent.initd" \
				 amavisd-snmp-subagent
		dodoc AMAVIS-MIB.txt
	fi

	perl_fix_packlist

	if use ldap ; then
		insinto /etc/openldap/schema
		newins contrib/LDAP.schema "${PN}.schema"
	fi

	# The config file should be root:amavis so that the amavis user can
	# read (only) it after dropping privileges. And of course he should
	# own everything in his home directory.
	insinto /etc
	insopts -m0640 -g amavis
	doins conf/amavisd.conf

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

	dodoc AAAREADME.first RELEASE_NOTES TODO \
		conf/amavisd.conf-default conf/amavisd-custom.conf \
		conf/amavisd-docker.conf

	docinto README_FILES
	dodoc READ_FILES/README*
	dodoc -r READ_FILES/*.{html,css}
	docinto README_FILES/images
	dodoc READ_FILES/images/*.png
	docinto README_FILES/images/callouts
	dodoc READ_FILES/images/callouts/*.png

	docinto test-messages
	dodoc t/messages/README
	dodoc t/messages/sample.tar.gz.compl
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
