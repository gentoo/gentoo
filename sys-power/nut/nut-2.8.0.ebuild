# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 flag-o-matic linux-info optfeature systemd tmpfiles toolchain-funcs udev

MY_P=${P/_/-}

DESCRIPTION="Network-UPS Tools"
HOMEPAGE="https://networkupstools.org/"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/networkupstools/${PN}.git"
else
	SRC_URI="https://networkupstools.org/source/${PV%.*}/${MY_P}.tar.gz"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

IUSE="cgi doc ipmi serial i2c +man snmp +usb modbus selinux split-usr ssl tcpd xml zeroconf"

DEPEND="
	acct-group/nut
	acct-user/nut
	cgi? ( >=media-libs/gd-2[png] )
	dev-libs/libltdl
	i2c? ( sys-apps/i2c-tools )
	ipmi? ( sys-libs/freeipmi )
	modbus? ( dev-libs/libmodbus )
	snmp? ( net-analyzer/net-snmp:= )
	ssl? ( >=dev-libs/openssl-1:= )
	tcpd? ( sys-apps/tcp-wrappers )
	usb? ( virtual/libusb:1 )
	virtual/udev
	xml? ( >=net-libs/neon-0.25.0:= )
	zeroconf? ( net-dns/avahi )
"

BDEPEND="
	man? ( app-text/asciidoc )
	virtual/pkgconfig
"

RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-nut )
"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${PN}-2.6.2-lowspeed-buffer-size.patch"
)

pkg_pretend() {
	if use i2c; then
		CONFIG_CHECK="~I2C_CHARDEV"
		ERROR_I2C_CHARDEV="You must enable I2C_CHARDEV in your kernel to continue"
	fi
	if use usb; then
		CONFIG_CHECK+=" ~HIDRAW ~USB_HIDDEV"
		ERROR_HIDRAW="HIDRAW is needed to support USB UPSes"
		ERROR_I2C_CHARDEV="USB_HIDDEV is needed to support USB UPSes"
	fi
	if use serial; then
		CONFIG_CHECK="~SERIAL_8250"
		ERROR_SERIAL_8250="SERIAL_8250 is needed to support Serial UPSes"
	fi

	# Now do the actual checks setup above
	check_extra_config
}

src_unpack() {
	if [[ "${PV}" == *9999 ]] ; then
		git-r3_src_unpack
	fi
	default
}

src_prepare() {
	default

	if [[ "${PV}" == *9999 ]] ; then
		./autogen.sh
	fi
}

src_configure() {
	local myeconfargs=(
		--datadir=/usr/share/nut
		--datarootdir=/usr/share/nut
		--disable-static
		--sysconfdir=/etc/nut
		--with-dev
		--with-drvpath="/$(get_libdir)/nut"
		--with-group=nut
		--with-htmlpath=/usr/share/nut/html
		--with-logfacility=LOG_DAEMON
		--with-statepath=/var/lib/nut
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		--with-user=nut
		--without-powerman
		--without-python
		--without-python2
		--without-python3
		--with-altpidpath=/run/nut
		--with-pidpath=/run/nut
		$(use_with i2c linux_i2c)
		$(use_with ipmi freeipmi)
		$(use_with ipmi)
		$(use_with serial)
		$(use_with snmp)
		$(use_with ssl)
		$(use_with tcpd wrap)
		$(use_with usb)
		$(use_with xml neon)
		$(use_with zeroconf avahi)
	)

	append-flags -fno-lto

	tc-export CC
	tc-export CXX
	tc-export AR

	use cgi && myeconfargs+=( --with-cgipath=/usr/share/nut/cgi )
	use man && myeconfargs+=( --with-doc=man )

	export bashcompdir="$(get_bashcompdir)"

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	rm -rf "${D}/etc/hotplug" || die

	find "${D}" -name '*.la' -delete || die

	dodir /sbin
	use split-usr && dosym ../usr/sbin/upsdrvctl /sbin/upsdrvctl

	if use cgi; then
		elog "CGI monitoring scripts are installed in /usr/share/nut/cgi."
		elog "copy them to your web server's ScriptPath to activate (this is a"
		elog "change from the old location)."
		elog "If you use lighttpd, see lighttpd_nut.conf in the documentation."
		elog
		elog "Use script aliases according to the web server you use (apache, nginx, lighttpd, etc...)"
	fi

	# this must be done after all of the install phases
	for i in "${D}"/etc/nut/*.sample ; do
		mv "${i}" "${i/.sample/}" || die
	done

	local DOCS=( AUTHORS MAINTAINERS NEWS README TODO UPGRADING )
	einstalldocs

	if use doc; then
		newdoc lib/README README.lib
		dodoc docs/*.txt
		docinto cables
		dodoc docs/cables/*
	fi

	newinitd "${FILESDIR}"/nut-2.8.0-init.d-upsd upsd
	newinitd "${FILESDIR}"/nut-2.2.2-init.d-upsdrv upsdrv
	newinitd "${FILESDIR}"/nut-2.6.5-init.d-upsmon upsmon
	newinitd "${FILESDIR}"/nut-2.6.5-init.d-upslog upslog
	newinitd "${FILESDIR}"/nut.powerfail.initd nut.powerfail

	newbashcomp "${S}"/scripts/misc/nut.bash_completion upsc
	bashcomp_alias upsc upscmd upsd upsdrvctl upsmon upsrw

	if use zeroconf; then
		insinto /etc/avahi/services
		doins scripts/avahi/nut.service
	fi

	mv "${D}"/usr/lib/tmpfiles.d/nut-common.tmpfiles "${D}"/usr/lib/tmpfiles.d/nut-common-tmpfiles.conf || die

	# Fix double directory
	sed -i -e 's:/nut/nut:/nut:g' "${D}"/usr/lib/tmpfiles.d/nut-common-tmpfiles.conf || die
}

pkg_postinst() {
	elog "Please note that NUT now runs under the 'nut' user."
	elog "NUT is in the uucp group for access to RS-232 UPS."
	elog "However if you use a USB UPS you may need to look at the udev or"
	elog "hotplug rules that are installed, and alter them suitably."
	elog
	elog "You are strongly advised to read the UPGRADING file provided by upstream."
	elog
	elog "Please note that upsdrv is NOT automatically started by upsd anymore."
	elog "If you have multiple UPS units, you can use their NUT names to"
	elog "have a service per UPS:"
	elog "ln -s /etc/init.d/upsdrv /etc/init.d/upsdrv.\$UPSNAME"
	elog
	elog 'If you want apcupsd to power off your UPS when it'
	elog 'shuts down your system in a power failure, you must'
	elog 'add nut.powerfail to your shutdown runlevel:'
	elog
	elog 'rc-update add nut.powerfail shutdown'
	elog

	optfeature "all notify events generate a global message (wall) to all users, plus they are logged via the syslog" \
		sys-apps/util-linu[logger,tty-helpers]

	udev_reload

	tmpfiles_process nut-common-tmpfiles.conf
}

pkg_postrm() {
	udev_reload
}
