# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools bash-completion-r1 eutils fixheadtails multilib user systemd flag-o-matic toolchain-funcs

MY_P=${P/_/-}

DESCRIPTION="Network-UPS Tools"
HOMEPAGE="http://www.networkupstools.org/"
# Nut mirrors are presently broken
SRC_URI="http://random.networkupstools.org/source/${PV%.*}/${MY_P}.tar.gz
	 http://www.networkupstools.org/source/${PV%.*}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd"

IUSE="cgi ipmi snmp +usb selinux ssl tcpd xml zeroconf"
CDEPEND="
	cgi? ( >=media-libs/gd-2[png] )
	snmp? ( net-analyzer/net-snmp )
	usb? ( virtual/libusb:0 )
	ssl? ( >=dev-libs/openssl-1 )
	tcpd? ( sys-apps/tcp-wrappers )
	xml? ( >=net-libs/neon-0.25.0 )
	ipmi? ( sys-libs/freeipmi )
	zeroconf? ( net-dns/avahi )
	virtual/udev"
DEPEND="$CDEPEND
	>=sys-apps/sed-4
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-nut )
"

S=${WORKDIR}/${MY_P}

# Bug #480664 requested UPS_DRIVERS_IUSE for more flexibility in building this package
SERIAL_DRIVERLIST="al175 bcmxcp belkin belkinunv bestfcom bestfortress bestuferrups bestups dummy-ups etapro everups gamatronic genericups isbmex liebert liebert-esp2 masterguard metasys oldmge-shut mge-utalk microdowell mge-shut oneac optiups powercom rhino safenet solis tripplite tripplitesu upscode2 victronups powerpanel blazer_ser clone clone-outlet ivtscd apcsmart apcsmart-old apcupsd-ups riello_ser nutdrv_qx"
SNMP_DRIVERLIST="snmp-ups"
USB_LIBUSB_DRIVERLIST="usbhid-ups bcmxcp_usb tripplite_usb blazer_usb richcomm_usb riello_usb nutdrv_qx"
USB_DRIVERLIST=${USB_LIBUSB_DRIVERLIST}
#HAL_DRIVERLIST="usbhid-ups bcmxcp_usb tripplite_usb blazer_usb riello_usb nutdrv_qx"
NEONXML_DRIVERLIST="netxml-ups"
IPMI_DRIVERLIST="nut-ipmipsu"
# Now we build from it:
for name in ${SERIAL_DRIVERLIST} ; do
	IUSE_UPS_DRIVERS="${IUSE_UPS_DRIVERS} +ups_drivers_${name}"
done
for name in ${USB_DRIVERLIST} ; do
	IUSE_UPS_DRIVERS="${IUSE_UPS_DRIVERS} +ups_drivers_${name}"
	REQUIRED_USE="${REQUIRED_USE} ups_drivers_${name}? ( usb )"
done
for name in ${NEONXML_DRIVERLIST}; do
	IUSE_UPS_DRIVERS="${IUSE_UPS_DRIVERS} ups_drivers_${name}"
	REQUIRED_USE="${REQUIRED_USE} ups_drivers_${name}? ( xml )"
done
for name in ${SNMP_DRIVERLIST} ; do
	IUSE_UPS_DRIVERS="${IUSE_UPS_DRIVERS} ups_drivers_${name}"
	REQUIRED_USE="${REQUIRED_USE} ups_drivers_${name}? ( snmp )"
done
for name in ${IPMI_DRIVERLIST} ; do
	IUSE_UPS_DRIVERS="${IUSE_UPS_DRIVERS} ups_drivers_${name}"
	REQUIRED_USE="${REQUIRED_USE} ups_drivers_${name}? ( ipmi )"
done
IUSE="${IUSE} ${IUSE_UPS_DRIVERS}"

# public files should be 644 root:root
NUT_PUBLIC_FILES="/etc/nut/{ups,upssched}.conf"
# private files should be 640 root:nut - readable by nut, writeable by root,
NUT_PRIVATE_FILES="/etc/nut/{upsd.conf,upsd.users,upsmon.conf}"
# public files should be 644 root:root, only installed if USE=cgi
NUT_CGI_FILES="/etc/nut/{{hosts,upsset}.conf,upsstats{,-single}.html}"

pkg_setup() {
	enewgroup nut 84
	enewuser nut 84 -1 /var/lib/nut nut,uucp
	# As of udev-104, NUT must be in uucp and NOT in tty.
	gpasswd -d nut tty 2>/dev/null
	gpasswd -a nut uucp 2>/dev/null
	# in some cases on old systems it wasn't in the nut group either!
	gpasswd -a nut nut 2>/dev/null
	warningmsg ewarn
}

src_prepare() {
	#ht_fix_file configure.in

	epatch "${FILESDIR}/nut-2.7.2/nut-2.7.2-no-libdummy.patch"
	epatch "${FILESDIR}"/${PN}-2.6.2-lowspeed-buffer-size.patch
	#epatch "${FILESDIR}"/${PN}-2.6.3-CVE-2012-2944.patch
	#epatch "${FILESDIR}"/${PN}-2.6.5-freeipmi_fru.patch
	epatch "${FILESDIR}"/${PN}-2.7.1-fix-scanning.patch
	epatch "${FILESDIR}"/${PN}-2.7.1-snmpusb-order.patch

	sed -e "s:GD_LIBS.*=.*-L/usr/X11R6/lib \(.*\) -lXpm -lX11:GD_LIBS=\"\1:" \
		-e '/systemdsystemunitdir=.*echo.*sed.*libdir/s,^,#,g' \
		-i configure.ac || die

	sed -e "s:52.nut-usbups.rules:70-nut-usbups.rules:" \
		-i scripts/udev/Makefile.am || die

	rm -f ltmain.sh m4/lt* m4/libtool.m4

	sed -i \
		-e 's:@LIBSSL_LDFLAGS@:@LIBSSL_LIBS@:' \
		lib/libupsclient{.pc,-config}.in || die #361685

	eautoreconf
}

src_configure() {
	local myconf
	append-flags -fno-lto
	tc-export CC
	tc-export CXX
	tc-export AR

	local UPS_DRIVERS=""
	for u in $USE ; do
		u2=${u#ups_drivers_}
		[[ "${u}" != "${u2}" ]] && UPS_DRIVERS="${UPS_DRIVERS} ${u2}"
	done
	UPS_DRIVERS="${UPS_DRIVERS# }" UPS_DRIVERS="${UPS_DRIVERS% }"
	myconf="${myconf} --with-drivers=${UPS_DRIVERS// /,}"

	use cgi && myconf="${myconf} --with-cgipath=/usr/share/nut/cgi"

	# TODO: USE flag for sys-power/powerman
	econf \
		--sysconfdir=/etc/nut \
		--datarootdir=/usr/share/nut \
		--datadir=/usr/share/nut \
		--disable-static \
		--with-statepath=/var/lib/nut \
		--with-drvpath=/$(get_libdir)/nut \
		--with-htmlpath=/usr/share/nut/html \
		--with-user=nut \
		--with-group=nut \
		--with-logfacility=LOG_DAEMON \
		--with-dev \
		--with-serial \
		--without-powerman \
		$(use_with cgi) \
		$(use_with ipmi) \
		$(use_with ipmi freeipmi) \
		$(use_with snmp) \
		$(use_with ssl) \
		$(use_with tcpd wrap) \
		$(use_with usb) \
		$(use_with xml neon) \
		$(use_with zeroconf avahi) \
		$(systemd_with_unitdir) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die

	find "${D}" -name '*.la' -exec rm -f {} +

	dodir /sbin
	dosym /usr/sbin/upsdrvctl /sbin/upsdrvctl

	if use cgi; then
		elog "CGI monitoring scripts are installed in /usr/share/nut/cgi."
		elog "copy them to your web server's ScriptPath to activate (this is a"
		elog "change from the old location)."
		elog "If you use lighttpd, see lighttpd_nut.conf in the documentation."
	fi

	# this must be done after all of the install phases
	for i in "${D}"/etc/nut/*.sample ; do
		mv "${i}" "${i/.sample/}"
	done

	dodoc AUTHORS ChangeLog docs/*.txt MAINTAINERS NEWS README TODO UPGRADING || die

	newdoc lib/README README.lib || die
	newdoc "${FILESDIR}"/lighttpd_nut.conf-2.2.0 lighttpd_nut.conf || die

	docinto cables
	dodoc docs/cables/* || die

	newinitd "${FILESDIR}"/nut-2.6.5-init.d-upsd upsd || die
	newinitd "${FILESDIR}"/nut-2.2.2-init.d-upsdrv upsdrv || die
	newinitd "${FILESDIR}"/nut-2.6.5-init.d-upsmon upsmon || die
	newinitd "${FILESDIR}"/nut-2.6.5-init.d-upslog upslog || die
	newinitd "${FILESDIR}"/nut.powerfail.initd nut.powerfail || die

	keepdir /var/lib/nut

	einfo "Setting up permissions on files and directories"
	fperms 0700 /var/lib/nut
	fowners nut:nut /var/lib/nut

	# Do not remove eval here, because the variables contain shell expansions.
	eval fperms 0640 ${NUT_PRIVATE_FILES}
	eval fowners root:nut ${NUT_PRIVATE_FILES}

	# Do not remove eval here, because the variables contain shell expansions.
	eval fperms 0644 ${NUT_PUBLIC_FILES}
	eval fowners root:root ${NUT_PUBLIC_FILES}

	# Do not remove eval here, because the variables contain shell expansions.
	if use cgi; then
		eval fperms 0644 ${NUT_CGI_FILES}
		eval fowners root:root ${NUT_CGI_FILES}
	fi

	# this is installed for 2.4 and fbsd guys
	if ! has_version virtual/udev; then
		einfo "Installing non-udev hotplug support"
		insinto /etc/hotplug/usb
		insopts -m 755
		doins scripts/hotplug/nut-usbups.hotplug
	fi

	dobashcomp "${S}"/scripts/misc/nut.bash_completion
}

pkg_postinst() {
	# this is to ensure that everybody that installed old versions still has
	# correct permissions

	chown nut:nut "${ROOT}"/var/lib/nut 2>/dev/null
	chmod 0700 "${ROOT}"/var/lib/nut 2>/dev/null

	# Do not remove eval here, because the variables contain shell expansions.
	eval chown root:nut "${ROOT}"${NUT_PRIVATE_FILES} 2>/dev/null
	eval chmod 0640 "${ROOT}"${NUT_PRIVATE_FILES} 2>/dev/null

	# Do not remove eval here, because the variables contain shell expansions.
	eval chown root:root "${ROOT}"${NUT_PUBLIC_FILES} 2>/dev/null
	eval chmod 0644 "${ROOT}"${NUT_PUBLIC_FILES} 2>/dev/null

	# Do not remove eval here, because the variables contain shell expansions.
	if use cgi; then
		eval chown root:root "${ROOT}"${NUT_CGI_FILES} 2>/dev/null
		eval chmod 0644 "${ROOT}"${NUT_CGI_FILES} 2>/dev/null
	fi

	warningmsg elog
}

warningmsg() {
	msgfunc="$1"
	[ -z "$msgfunc" ] && die "msgfunc not specified in call to warningmsg!"
	${msgfunc} "Please note that NUT now runs under the 'nut' user."
	${msgfunc} "NUT is in the uucp group for access to RS-232 UPS."
	${msgfunc} "However if you use a USB UPS you may need to look at the udev or"
	${msgfunc} "hotplug rules that are installed, and alter them suitably."
	${msgfunc} ''
	${msgfunc} "You are strongly advised to read the UPGRADING file provided by upstream."
	${msgfunc} ''
	${msgfunc} "Please note that upsdrv is NOT automatically started by upsd anymore."
	${msgfunc} "If you have multiple UPS units, you can use their NUT names to"
	${msgfunc} "have a service per UPS:"
	${msgfunc} "ln -s /etc/init.d/upsdrv /etc/init.d/upsdrv.\$UPSNAME"
	${msgfunc} ''
	${msgfunc} 'If you want apcupsd to power off your UPS when it'
	${msgfunc} 'shuts down your system in a power failure, you must'
	${msgfunc} 'add nut.powerfail to your shutdown runlevel:'
	${msgfunc} ''
	${msgfunc} 'rc-update add nut.powerfail shutdown'
	${msgfunc} ''

}
