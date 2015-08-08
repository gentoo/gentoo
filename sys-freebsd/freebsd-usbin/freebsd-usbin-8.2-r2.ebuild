# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit bsdmk freebsd flag-o-matic eutils

DESCRIPTION="FreeBSD /usr/sbin tools"
SLOT="0"
KEYWORDS="~sparc-fbsd ~x86-fbsd"

SRC_URI="mirror://gentoo/${P}.tar.bz2
		mirror://gentoo/${CONTRIB}.tar.bz2
		mirror://gentoo/${UBIN}.tar.bz2
		mirror://gentoo/${LIB}.tar.bz2
		mirror://gentoo/${SBIN}.tar.bz2
		mirror://gentoo/${ETC}.tar.bz2
		mirror://gentoo/${GNU}.tar.bz2
		nis? ( mirror://gentoo/${LIBEXEC}.tar.bz2 )
		build? ( mirror://gentoo/${SYS}.tar.bz2
			mirror://gentoo/${INCLUDE}.tar.bz2 )"

RDEPEND="=sys-freebsd/freebsd-lib-${RV}*[usb?,bluetooth?,netware?]
	=sys-freebsd/freebsd-libexec-${RV}*
	acpi? ( sys-power/iasl )
	build? ( sys-apps/baselayout )
	ssl? ( dev-libs/openssl )
	dev-libs/libelf
	dev-libs/libedit
	net-libs/libpcap"
DEPEND="${RDEPEND}
	=sys-freebsd/freebsd-mk-defs-${RV}*
	=sys-freebsd/freebsd-ubin-${RV}*
	!build? ( =sys-freebsd/freebsd-sources-${RV}* )
	sys-apps/texinfo
	sys-devel/flex"

S="${WORKDIR}/usr.sbin"

IUSE="acpi atm audit bluetooth floppy ipv6 minimal netware nis pam ssl usb build"

pkg_setup() {
	# Release crunch is something like minimal. It seems to remove everything
	# which is not needed to work.
	use minimal && mymakeopts="${mymakeopts} RELEASE_CRUNCH= "

	use acpi || mymakeopts="${mymakeopts} WITHOUT_ACPI= "
	use atm || mymakeopts="${mymakeopts} WITHOUT_ATM= "
	use audit || mymakeopts="${mymakeopts} WITHOUT_AUDIT= "
	use bluetooth || mymakeopts="${mymakeopts} WITHOUT_BLUETOOTH= "
	use ipv6 || mymakeopts="${mymakeopts} WITHOUT_INET6= WITHOUT_INET6_SUPPORT= "
	use netware || mymakeopts="${mymakeopts} WITHOUT_IPX= WITHOUT_IPX_SUPPORT= WITHOUT_NCP= "
	use nis || mymakeopts="${mymakeopts} WITHOUT_NIS= "
	use pam || mymakeopts="${mymakeopts} WITHOUT_PAM_SUPPORT= "
	use ssl || mymakeopts="${mymakeopts} WITHOUT_OPENSSL= "
	use usb || mymakeopts="${mymakeopts} WITHOUT_USB= "
	use floppy || mymakeopts="${mymakeopts} WITHOUT_FLOPPY= "

	mymakeopts="${mymakeopts} WITHOUT_BIND_NAMED= WITHOUT_BIND_DNSSEC= WITHOUT_PF= WITHOUT_LPR= WITHOUT_SENDMAIL= WITHOUT_AUTHPF= WITHOUT_MAILWRAPPER= "

	append-flags $(test-flags -fno-strict-aliasing)
}

PATCHES=( "${FILESDIR}/${PN}-7.0-nowrap.patch"
	"${FILESDIR}/${PN}-adduser.patch"
	"${FILESDIR}/mountd.patch"
	"${FILESDIR}/${PN}-8.2-newsyslog.patch" )

REMOVE_SUBDIRS="
	named named-checkzone named-checkconf rndc rndc-confgen
	dnssec-keygen dnssec-signzone
	tcpdchk tcpdmatch
	sendmail praliases editmap mailstats makemap
	sysinstall cron mailwrapper ntp bsnmpd
	tcpdump ndp inetd
	wpa/wpa_supplicant wpa/hostapd wpa/hostapd_cli wpa/wpa_cli wpa/wpa_passphrase
	zic amd
	pkg_install freebsd-update"

src_prepare() {
	if ! use build; then
		ln -s "/usr/src/sys-${RV}" "${WORKDIR}/sys"
		ln -s "/usr/include" "${WORKDIR}/include"
	else
		dummy_mk mount_smbfs
	fi
	# Don't install mtree format manpage
	# it's installed by libarchive.
	sed -e "s: mtree.5::g" -i "${S}"/mtree/Makefile
}

src_install() {
	# By creating these directories we avoid having to do a
	# more complex hack
	dodir /usr/share/doc
	dodir /sbin
	dodir /usr/libexec
	dodir /usr/bin

	# FILESDIR is used by some makefiles which will install files
	# in the wrong place, just put it in the doc directory.
	mkinstall DOCDIR=/usr/share/doc/${PF} || die "Install failed"

	# Most of these now come from openrc.
	for util in nfs rpc.statd rpc.lockd; do
		newinitd "${FILESDIR}/"${util}.initd ${util} || die
		if [[ -e "${FILESDIR}"/${util}.confd ]]; then \
			newconfd "${FILESDIR}"/${util}.confd ${util} || die
		fi
	done

	for class in daily monthly weekly; do
		cat - > "${T}/periodic.${class}" <<EOS
#!/bin/sh
/usr/sbin/periodic ${class}
EOS
		exeinto /etc/cron.${class}
		newexe "${T}/periodic.${class}" periodic
	done

	# Install the pw.conf file to let pw use Gentoo's skel location
	insinto /etc
	doins "${FILESDIR}/pw.conf" || die

	cd "${WORKDIR}/etc"
	doins apmd.conf syslog.conf newsyslog.conf nscd.conf || die

	insinto /etc/ppp
	doins ppp/ppp.conf || die

	if use bluetooth; then
		insinto /etc/bluetooth
		doins bluetooth/* || die
		rm -f "${D}"/etc/bluetooth/Makefile
	fi

	# Install the periodic stuff (needs probably to be ported in a more
	# gentooish way)
	cd "${WORKDIR}/etc/periodic"

	doperiodic daily daily/*.accounting
	doperiodic monthly monthly/*.accounting
}

pkg_postinst() {
	# We need to run pwd_mkdb if key files are not present
	# If they are, then there is no need to run pwd_mkdb
	if [[ ! -e "${ROOT}etc/passwd" || ! -e "${ROOT}etc/pwd.db" || ! -e "${ROOT}etc/spwd.db" ]] ; then
		if [[ -e "${ROOT}etc/master.passwd" ]] ; then
			einfo "Generating passwd files from ${ROOT}etc/master.passwd"
			"${ROOT}"usr/sbin/pwd_mkdb -p -d "${ROOT}etc" "${ROOT}etc/master.passwd"
		else
			eerror "${ROOT}etc/master.passwd does not exist!"
			eerror "You will no be able to log into your system!"
		fi
	fi

	for logfile in messages security auth.log maillog lpd-errs xferlog cron \
		debug.log slip.log ppp.log; do
		[[ -f "${ROOT}/var/log/${logfile}" ]] || touch "${ROOT}/var/log/${logfile}"
	done
}
