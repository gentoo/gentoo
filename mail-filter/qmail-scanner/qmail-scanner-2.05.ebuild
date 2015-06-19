# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/qmail-scanner/qmail-scanner-2.05.ebuild,v 1.11 2014/08/10 21:16:56 slyfox Exp $

inherit fixheadtails toolchain-funcs eutils user

Q_S_DATE=20080728
DESCRIPTION="E-Mail virus scanner for qmail"
HOMEPAGE="http://qmail-scanner.sourceforge.net/"
SRC_URI="mirror://sourceforge/qmail-scanner/${P}.tgz
		http://toribio.apollinare.org/qmail-scanner/download/q-s-${PV}st-${Q_S_DATE}.patch.gz"

IUSE="clamav spamassassin"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
RESTRICT="userpriv"

RDEPEND="dev-lang/perl
	virtual/perl-Time-HiRes
	net-mail/tnef
	virtual/perl-DB_File
	mail-filter/maildrop
	virtual/qmail
	app-arch/unzip
	virtual/daemontools
	clamav? ( app-antivirus/clamav )
	spamassassin? ( mail-filter/spamassassin )"
DEPEND="${RDEPEND}"

pkg_setup() {
	enewgroup qscand 210
	enewuser qscand 210 -1 /var/spool/qscan qscand
	use clamav && usermod -a -G qscand,nofiles clamav
}

pkg_preinst() {
	local oldname="/var/qmail/bin/qmail-scanner-queue.pl"
	if [ -f ${oldname} ]; then
		newname=${oldname}.`date +%Y%m%d%H%M%S`
		elog "Backing up old qmail-scanner as $newname in case of modifications."
		cp ${oldname} ${newname}
		chmod 600 ${newname}
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${DISTDIR}"/q-s-${PV}st-${Q_S_DATE}.patch.gz
	epatch "${FILESDIR}"/${PN}-2.08-disable-suid-check.patch #364123
	ht_fix_file autoupdaters/* configure
	sed -i \
		-e "s:/var/spool/qscand:/var/spool/qscan:g" \
		README-st-patch.html \
		README-st-patch.txt || die "Fixing doc with sed failed"

	EXTRA_VIRII="bagle,beagle,mydoom,sco,maldal,mimail,novarg,shimg,bugler,cissi,cissy,dloade,netsky,qizy"
	elog "Adding items to the SILENT_VIRUSES list (${EXTRA_VIRII})"
	sed -e "/^SILENT_VIRUSES/s/\"$/,${EXTRA_VIRII}\"/g"  -i configure
}

src_compile () {
	local myconf

	addpredict /var/log/kav/kavscan.log
	addpredict /opt/bdc/plugins.htm

	use spamassassin && myconf="--virus-to-delete yes --sa-quarantine 2.1 --sa-delete 4.2 --sa-reject no --sa-subject SPAM: --sa-delta 0.5 --sa-alt yes"

	PATH=${PATH}:/opt/f-prot:/opt/vlnx ./configure \
	--domain localhost \
	--batch \
	--log-details yes \
	--skip-setuid-test \
	${myconf} \
	|| die "./configure failed!"

	# build for qmail-scanner-queue wrapper, so we don't need suidperl
	cd contrib
	$(tc-getCC) ${CFLAGS} -o qmail-scanner-queue qmail-scanner-queue.c || die
}

src_install () {
	# Create Directory Structure
	diropts -m 755 -o qscand -g qscand
	dodir /var/spool/qscan
	keepdir /var/spool/qscan
	diropts -m 750 -o qscand -g qscand
	dodir /var/spool/qscan/quarantine
	for i in quarantine/{viruses,policy,spam} working archives; do
		for j in tmp new cur; do
			dodir /var/spool/qscan/${i}/${j}
			keepdir /var/spool/qscan/${i}/${j}
		done
	done
	dodir /var/spool/qscan/tmp
	keepdir /var/spool/qscan/tmp

	# Install standard quarantine events file
	insinto /var/spool/qscan
	insopts -m 644 -o qscand -g qscand
	doins quarantine-events.txt

	# create quarantine.log and viruses.log
	touch quarantine.log
	insinto /var/spool/qscan
	insopts -m 644 -o qscand -g qscand
	doins quarantine.log
	dosym quarantine.log ${DESTDIR}/var/spool/qscan/viruses.log

	# Install qmail-scanner wrapper
	insinto /var/qmail/bin
	insopts -m 4755 -o qscand -g qscand
	doins contrib/qmail-scanner-queue

	# Install qmail-scanner script
	insinto /var/qmail/bin
	insopts -m 0755 -o qscand -g qscand
	doins qmail-scanner-queue.pl

	insinto /etc/logrotate.d/
	insopts -m 644 -o root -g root
	newins "${FILESDIR}"/${P}.logrotate qmail-scanner

	exeinto /etc/cron.daily/
	newexe "${FILESDIR}"/qmailscanner.cronjob qmail-scanner

	# Install documentation
	dodoc README CHANGES
	dohtml README.html FAQ.php TODO.php configure-options.php manual-install.php perlscanner.php

	docinto contrib
	cd "${S}"/contrib
	dodoc spamc-nice.eml \
		test-trophie.pl \
		logrotate.qmail-scanner \
		sub-avpdaemon.pl \
		logging_first_80_chars.eml \
		spamc-nasty.eml \
		avpdeamon.init \
		test_installation.sh \
		test-sophie.pl \
		reformime-test.eml \
		sub-sender-cache.pl \
		rbl_scanner.txt \
		test-clamd.pl \
		qs2mrtg.pl \
		mrtg-qmail-scanner.cfg \
		check_AV_daemons \
		patch_for_nod32_single_user.eml \
		qmail-delay \
		qs-scanner-report.sh \
		qs_config.sh \
		qscan-spam-to-users.pl \
		test-avgd.pl \
		test_password.zip \
		vpopmail-issues.eml
}

pkg_postinst () {
	einfo "Fixing ownerships"
	chown -R qscand:qscand /var/spool/qscan
	touch /var/qmail/bin/qmail-scanner-queue.pl

	# Setup perlscanner + Version Info
	chmod -s "${ROOT}"/var/qmail/bin/qmail-scanner-queue.pl
	"${ROOT}"/var/qmail/bin/qmail-scanner-queue -z
	"${ROOT}"/var/qmail/bin/qmail-scanner-queue -g

	elog "To activate qmail-scanner, please edit your"
	elog "/var/qmail/control/conf-common file and set:"
	elog "export QMAILQUEUE=/var/qmail/bin/qmail-scanner-queue"
	elog "Or place it in your tcprules file."
	ewarn "Please note that it was a call to qmail-scanner-queue.pl before,"
	ewarn "but this is now changed to use a wrapper to improve security!"
	ewarn "Once you have changed to the wrapper, you can remove the setuid "
	ewarn "bit on qmail-scanner-queue.pl"

	ewarn "If this is an upgrade from <=2.0.1 the home directory of the qscand"
	ewarn "user is changed. Please update it manually to /var/spool/qscan"
	ewarn "or remove the user and emerge again this package"

	if use clamav; then
		ewarn "To allow clamav integration comment-out in /etc/clamd.conf:"
		ewarn "AllowSupplementaryGroups putting yes."
		ewarn "After that, restart clamd with"
		ewarn "/etc/init.d/clamd restart"
	fi
}
