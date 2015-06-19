# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-mta/courier/courier-0.74.1.ebuild,v 1.3 2015/01/15 08:46:07 nativemad Exp $

inherit eutils flag-o-matic multilib

DESCRIPTION="An MTA designed specifically for maildirs"
SRC_URI="mirror://sourceforge/courier/${P}.tar.bz2"
HOMEPAGE="http://www.courier-mta.org/"
SLOT="0"
LICENSE="GPL-2"
# not in keywords due to missing dependencies:
# ~arm ~s390 ~ppc64 ~alpha ~hppa ~ia64 ~ppc ~sparc ~x86
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="postgres ldap mysql pam nls ipv6 spell fax crypt norewrite \
	fam web webmail gnutls"

DEPEND="
	>=net-libs/courier-authlib-0.66.1
	net-libs/courier-unicode
	!gnutls? ( >=dev-libs/openssl-0.9.6 )
	gnutls? ( net-libs/gnutls )
	>=sys-libs/gdbm-1.8.0
	dev-libs/libpcre
	app-misc/mime-types
	fax? ( >=media-libs/netpbm-9.12 app-text/ghostscript-gpl >=net-dialup/mgetty-1.1.28 )
	pam? ( virtual/pam )
	mysql? ( virtual/mysql )
	ldap? ( >=net-nds/openldap-1.2.11 )
	postgres? ( dev-db/postgresql )
	spell? ( app-text/aspell )
	fam? ( virtual/fam )
	!mail-filter/maildrop
	!mail-mta/esmtp
	!mail-mta/exim
	!mail-mta/mini-qmail
	!mail-mta/msmtp
	!mail-mta/netqmail
	!mail-mta/nullmailer
	!mail-mta/postfix
	!mail-mta/qmail-ldap
	!mail-mta/sendmail
	!mail-mta/ssmtp
	!mail-mta/opensmtpd
	!net-mail/dot-forward
	!sys-apps/ucspi-tcp
	"

RDEPEND="${DEPEND}
	dev-lang/perl
	sys-process/procps"

# get rid of old style virtual/imapd - bug 350792
# all blockers really needed?
RDEPEND="${RDEPEND}
	!net-mail/bincimap
	!net-mail/courier-imap
	!net-mail/cyrus-imapd
	!net-mail/uw-imap"

PDEPEND="pam? ( net-mail/mailbase )
	crypt? ( >=app-crypt/gnupg-1.0.4 )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	use norewrite && epatch "${FILESDIR}/norewrite.patch"
}

src_compile() {
	filter-flags '-fomit-frame-pointer'

	local myconf
	myconf=""

	use ldap && myconf="${myconf} --with-ldapconfig=/etc/courier/maildropldap.conf"

	econf ${myconf} \
		$(use_with fam) \
		$(use_with ipv6) \
		$(use_with spell ispell) \
		$(use_with ldap ldapaliasd) \
		$(use_enable ldap maildroldap) \
		$(use_with gnutls) \
		--enable-mimetypes=/etc/mime.types \
		--prefix=/usr \
		--disable-root-check \
		--mandir=/usr/share/man \
		--sysconfdir=/etc/courier \
		--libexecdir=/usr/$(get_libdir)/courier \
		--datadir=/usr/share/courier \
		--sharedstatedir=/var/lib/courier/com \
		--localstatedir=/var/lib/courier \
		--with-piddir=/var/run/courier \
		--with-authdaemonvar=/var/lib/courier/authdaemon \
		--with-mailuser=mail \
		--with-mailgroup=mail \
		--with-paranoid-smtpext \
		--with-db=gdbm \
		--disable-autorenamesent \
		--cache-file="${S}/configuring.cache" \
		--host="${CHOST}" debug=true || die "./configure"
	sed -e'/^install-perms-local:/a\	sed -e\"s|^|'"${D}"'|g\" -i permissions.dat' -i Makefile
	emake || die "Compile problem"
}

etc_courier() {
	# Import existing /etc/courier/file if it exists.
	# Add option only if it was not already set or even commented out
	file="${1}" ; word="`echo \"${2}\" | sed -e\"s|=.*$||\" -e\"s|^.*opt ||\"`"
	[ ! -e "${D}/etc/courier/${file}" ] && [ -e "/etc/courier/${file}" ] && \
			cp "/etc/courier/${file}" "${D}/etc/courier/${file}"
	grep -q "${word}" "${D}/etc/courier/${file}" || \
		echo "${2}" >> "${D}/etc/courier/${file}"
}

etc_courier_chg() {
	file="${1}" ; key="${2}" ; value="${3}" ; section="${4}"
	[ -z "${section}" ] && section="${2}"
	grep -q "${key}" "${file}" && elog "Changing ${file}: ${key} to ${value}"
	sed -i -e"/\#\#NAME: ${section}/,+30 s|${key}=.*|${key}=\"${value}\"|g" ${file}
}

src_install() {
	local f
	diropts -o mail -g mail
	keepdir /var/lib/courier/tmp
	keepdir /var/lib/courier/msgs
	make install DESTDIR="${D}" || die "install"
	make install-configure || die "install-configure"

	# Get rid of files we dont want
	if ! use webmail ; then
		rm -rf "${D}/usr/$(get_libdir)/courier/courier/webmail" \
			"${D}/usr/$(get_libdir)/courier/courier/sqwebmaild" \
			"${D}/usr/share/courier/sqwebmail/" \
			"${D}/usr/sbin/webmaild" \
			"${D}/usr/sbin/webgpg" \
			"${D}/etc/courier/webmail.authpam" \
			"${D}/var/lib/courier/webmail-logincache" \
			"${D}"/etc/courier/sqwebmaild*
	fi

	if ! use web ; then
		rm -rf "${D}/usr/share/courier/courierwebadmin/" \
			"${D}/etc/courier/webadmin"
	fi

	for dir2keep in $(cd "${D}" && find ./var/lib/courier -type d) ; do
		keepdir "$dir2keep" || die "failed running keepdir: $dir2keep"
	done

	newinitd "${FILESDIR}/courier-init-r4" "courier"
	use fam || sed -i -e's|^.*use famd$||g' "${D}/etc/init.d/courier"

	cd "${D}/etc/courier"
	if use webmail ; then
		insinto /etc/courier
		newins "${FILESDIR}/apache-sqwebmail.inc" apache-sqwebmail.inc
	fi

	for f in *.dist ; do cp "${f}" "${f%%.dist}" ; done
	if use ldap ; then
		[ -e ldapaliasrc ] &&  ( chown root:0 ldapaliasrc ; chmod 400 ldapaliasrc )
	else
		rm -f ldapaliasrc
	fi

	( [ -e /etc/courier/sizelimit ] && cat /etc/courier/sizelimit || echo 0 ) \
		> "${D}/etc/courier/sizelimit"
	etc_courier maildroprc ""
	etc_courier esmtproutes ""
	etc_courier backuprelay ""
	etc_courier locallowercase ""
	etc_courier bofh "opt BOFHBADMIME=accept"
	etc_courier bofh "opt BOFHSPFTRUSTME=1"
	etc_courier bofh "opt BOFHSPFHELO=pass,neutral,unknown,none,error,softfail,fail"
	etc_courier bofh "opt BOFHSPFHELO=pass,neutral,unknown,none"
	etc_courier bofh "opt BOFHSPFFROM=all"
	etc_courier bofh "opt BOFHSPFMAILFROM=all"
	etc_courier bofh "#opt BOFHSPFHARDERROR=fail"
	etc_courier esmtpd "BOFHBADMIME=accept"
	etc_courier esmtpd-ssl "BOFHBADMIME=accept"
	etc_courier esmtpd-msa "BOFHBADMIME=accept"

	use fam && etc_courier_chg imapd IMAP_CAPABILITY "IMAP4rev1 UIDPLUS CHILDREN NAMESPACE THREAD=ORDEREDSUBJECT THREAD=REFERENCES SORT QUOTA AUTH=CRAM-MD5 AUTH=CRAM-SHA1 AUTH=CRAM-SHA256 IDLE"
	use fam || etc_courier_chg imapd IMAP_CAPABILITY "IMAP4rev1 UIDPLUS CHILDREN NAMESPACE THREAD=ORDEREDSUBJECT THREAD=REFERENCES SORT QUOTA AUTH=CRAM-MD5 AUTH=CRAM-SHA1 AUTH=CRAM-SHA256"

	# Fix for a sandbox violation on subsequential merges
	# - ticho@gentoo.org, 2005-07-10
	dosym /usr/share/courier/pop3d /usr/sbin/courier-pop3d
	dosym /usr/share/courier/pop3d-ssl /usr/sbin/courier-pop3d-ssl
	dosym /usr/share/courier/imapd /usr/sbin/courier-imapd
	dosym /usr/share/courier/imapd-ssl /usr/sbin/courier-imapd-ssl

	cd "${S}"
	cp imap/README README.imap
	use nls && cp unicode/README README.unicode
	dodoc AUTHORS BENCHMARKS COPYING* ChangeLog* INSTALL NEWS README* TODO courier/doc/*.txt
	dodoc tcpd/README.couriertls
	mv "${D}/usr/share/courier/htmldoc" "${D}/usr/share/doc/${PF}/html"

	if use webmail ; then
		insinto /usr/$(get_libdir)/courier/courier
		insopts -m 755 -o mail -g mail
		doins "${S}/courier/webmaild"
	fi

	if use web ; then
		insinto /etc/courier/webadmin
		insopts -m 400 -o mail -g mail
		doins "${FILESDIR}/password.dist"
	fi

	# avoid name collisions in /usr/sbin, make webadmin match
	cd "${D}/usr/sbin"
	for f in imapd imapd-ssl pop3d pop3d-ssl ; do mv "${f}" "courier-${f}" ; done
	if use web ; then
		sed -i -e 's:\$sbindir\/imapd:\$sbindir\/courier-imapd:g' \
			-e 's:\$sbindir\/imapd-ssl:\$sbindir\/courier-imapd-ssl:g' \
			"${D}/usr/share/courier/courierwebadmin/admin-40imap.pl" \
			|| ewarn "failed to fix webadmin"
		sed -i -e 's:\$sbindir\/pop3d:\$sbindir\/courier-pop3d:g' \
			-e 's:\$sbindir\/pop3d-ssl:\$sbindir\/courier-pop3d-ssl:g' \
			"${D}/usr/share/courier/courierwebadmin/admin-45pop3.pl" \
			|| ewarn "failed to fix webadmin"
	fi

	# users should be able to send mail. Could be restricted with suictl.
	chmod u+s "${D}/usr/bin/sendmail"

	dosym /usr/bin/sendmail /usr/sbin/sendmail
}

src_test() {
	if [ `whoami` != 'root' ]; then
		emake -j1 check || die "Make check failed."
	else
		einfo "make check skipped, can't run as root."
		einfo "You can enable it with FEATURES=\"userpriv\""
	fi
}

pkg_postinst() {
	use fam && elog "fam daemon is needed for courier-imapd" \
		|| ewarn "courier was built without fam support"
}

pkg_config() {
	mailhost="$(hostname)"
	export mailhost

	domainname="$(domainname)"
	if [ "x$domainname" = "x(none)" ] ; then
		domainname="$(echo ${mailhost} | sed -e "s/[^\.]*\.\(.*\)/\1/")"
	fi
	export domainname

	if [ "${ROOT}" = "/" ] ; then
		file="${ROOT}/etc/courier/locals"
		if [ ! -f "${file}" ] ; then
			echo "localhost" > "${file}";
			echo "${domainname}" >> "${file}";
		fi
		file="${ROOT}/etc/courier/esmtpacceptmailfor.dir/${domainname}"
		if [ ! -f "${file}" ] ; then
			echo "${domainname}" > "${file}"
			/usr/sbin/makeacceptmailfor
		fi

		file="${ROOT}/etc/courier/smtpaccess/${domainname}"
		if [ ! -f "${file}" ]
		then
			netstat -nr | grep "^[1-9]" | while read network gateway netmask rest
			do
				i=1
				net=""
				TIFS="${IFS}"
				IFS="."
				for o in "${netmask}"
				do
					if [ "${o}" == "255" ]
					then
						[ "_${net}" == "_" ] || net="${net}."
						t="$(echo "${network}" | cut -d " " -f ${i})"
						net="${net}${t}"
					fi
					i="$((${i} + 1))"
				done
				IFS="${TIFS}"
				echo "doing configuration - relay control for the network ${net} !"
				echo "${net}	allow,RELAYCLIENT" >> ${file}
			done
			/usr/sbin/makesmtpaccess
		fi
	fi

	echo "creating cert for esmtpd-ssl:"
	/usr/sbin/mkesmtpdcert
	echo "creating cert for imapd-ssl:"
	/usr/sbin/mkpop3dcert
	echo "creating cert for pop3d-ssl:"
	/usr/sbin/mkimapdcert
}
