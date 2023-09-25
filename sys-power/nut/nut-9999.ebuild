# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit bash-completion-r1 desktop flag-o-matic linux-info optfeature
inherit python-single-r1 systemd tmpfiles toolchain-funcs udev wrapper xdg

MY_P=${P/_/-}

DESCRIPTION="Network-UPS Tools"
HOMEPAGE="https://networkupstools.org/"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/networkupstools/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://networkupstools.org/source/${PV%.*}/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
IUSE="gpio cgi doc ipmi serial i2c +man snmp +usb modbus selinux split-usr ssl tcpd test xml zeroconf python monitor systemd"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	monitor? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
	snmp? ( python )
"

# sys-apps/systemd-253 required for Type=notify-reload
DEPEND="
	acct-group/nut
	acct-user/nut
	dev-libs/libltdl
	virtual/udev
	cgi? ( >=media-libs/gd-2[png] )
	gpio? ( dev-libs/libgpiod )
	i2c? ( sys-apps/i2c-tools )
	ipmi? ( sys-libs/freeipmi )
	modbus? ( dev-libs/libmodbus )
	python? ( ${PYTHON_DEPS} )
	snmp? ( net-analyzer/net-snmp:= )
	ssl? ( >=dev-libs/openssl-1:= )
	systemd? ( >=sys-apps/systemd-253 )
	tcpd? ( sys-apps/tcp-wrappers )
	usb? ( virtual/libusb:1 )
	xml? ( >=net-libs/neon-0.25.0:= )
	zeroconf? ( net-dns/avahi )
"
BDEPEND="
	virtual/pkgconfig
	man? ( app-text/asciidoc )
	test? ( dev-util/cppunit )
"
RDEPEND="
	${DEPEND}
	monitor? ( $(python_gen_cond_dep '
			dev-python/PyQt5[gui,widgets,${PYTHON_USEDEP}]
		')
	)
	selinux? ( sec-policy/selinux-nut )
"

PATCHES=(
	"${FILESDIR}/${PN}-2.6.2-lowspeed-buffer-size.patch"
	"${FILESDIR}/systemd_notify.path"
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
	if use gpio; then
		CONFIG_CHECK="~GPIO_CDEV_V1"
		ERROR_GPIO_CDEV_V1="GPIO_CDEV_V1 is needed to support GPIO UPSes"
	fi
	if use serial; then
		CONFIG_CHECK="~SERIAL_8250"
		ERROR_SERIAL_8250="SERIAL_8250 is needed to support Serial UPSes"
	fi

	# Now do the actual checks setup above
	check_extra_config
}

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	if [[ ${PV} == *9999 ]] ; then
		./autogen.sh || die
	fi

	xdg_environment_reset
}

src_configure() {
	local myeconfargs=(
		--datadir=/usr/share/nut
		--datarootdir=/usr/share/nut
		--disable-static
		--disable-strip
		--disable-Werror
		--sysconfdir=/etc/nut
		--with-dev
		--with-drvpath="/$(get_libdir)/nut"
		--with-group=nut
		--with-htmlpath=/usr/share/nut/html
		--with-logfacility=LOG_DAEMON
		--with-statepath=/var/lib/nut
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		--with-systemdtmpfilesdir="/usr/lib/tmpfiles.d"
		--with-udev-dir="$(get_udevdir)"
		--with-user=nut
		--without-powerman
		--without-python
		--without-python2
		--with-altpidpath=/run/nut
		--with-pidpath=/run/nut
		$(use_with cgi)
		$(use_with gpio)
		$(use_with i2c linux_i2c)
		$(use_with ipmi freeipmi)
		$(use_with ipmi)
		$(use_with monitor nut_monitor)
		$(use_with python pynut)
		$(use_with serial)
		$(use_with snmp)
		$(use_with ssl)
		$(use_with systemd libsystemd)
		$(use_with tcpd wrap)
		$(use_with usb)
		$(use_with xml neon)
		$(use_with zeroconf avahi)
	)

	filter-lto
	append-flags -fno-lto
	tc-export CC CXX AR

	use cgi && myeconfargs+=( --with-cgipath=/usr/share/nut/cgi )
	use man && myeconfargs+=( --with-doc=man )
	use python && myeconfargs+=( --with-python3="${PYTHON}" ) || myeconfargs+=( --without-python3 )

	export bashcompdir="$(get_bashcompdir)"

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	rm -rf "${ED}/etc/hotplug" || die

	find "${ED}" -name '*.la' -delete || die

	dodir /sbin
	use split-usr && dosym ../usr/sbin/upsdrvctl /sbin/upsdrvctl

	if use cgi; then
		elog "CGI monitoring scripts are installed in ${EPREFIX}/usr/share/nut/cgi."
		elog "copy them to your web server's ScriptPath to activate (this is a"
		elog "change from the old location)."
		elog "If you use lighttpd, see lighttpd_nut.conf in the documentation."
		elog
		elog "Use script aliases according to the web server you use (apache, nginx, lighttpd, etc...)"
	fi

	# This must be done after all of the install phases
	local i
	for i in "${ED}"/etc/nut/*.sample ; do
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

	if use monitor; then
		make_wrapper NUT-Monitor-py3qt5 /usr/share/nut/nut-monitor/app/NUT-Monitor-py3qt5 /usr/share/nut/nut-monitor/app

		# Install desktop shortcut
		newmenu scripts/python/app/nut-monitor-py3qt5.desktop nut-monitor.desktop

		# Installing Application icons
		local res
		for res in 48 64 256; do
			doicon -s ${res} scripts/python/app/icons/${res}x${res}/nut-monitor.png
		done
		doicon -s scalable scripts/python/app/icons/scalable/nut-monitor.svg
	fi

	use python && python_optimize
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
		sys-apps/util-linux[logger,tty-helpers]

	udev_reload

	tmpfiles_process nut-common-tmpfiles.conf
	xdg_pkg_postinst
}

pkg_postrm() {
	udev_reload
	xdg_pkg_postrm
}
