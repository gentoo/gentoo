# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info systemd udev tmpfiles

DESCRIPTION="APC UPS daemon with integrated tcp/ip remote shutdown"
HOMEPAGE="http://www.apcupsd.org/"
SRC_URI="https://downloads.sourceforge.net/apcupsd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~riscv ~x86"
IUSE="cgi +modbus selinux snmp +usb"

DEPEND="
	sys-apps/util-linux[tty-helpers]
	cgi? ( media-libs/gd:2= )
	modbus? (
		usb? ( virtual/libusb:0= )
	)
	snmp? ( net-analyzer/net-snmp )
"

RDEPEND="
	virtual/mailx
	selinux? ( sec-policy/selinux-apcupsd )
	${DEPEND}
"

CONFIG_CHECK="~USB_HIDDEV ~HIDRAW"
ERROR_USB_HIDDEV="CONFIG_USB_HIDDEV:	needed to access USB-attached UPSes"
ERROR_HIDRAW="CONFIG_HIDRAW:		needed to access USB-attached UPSes"

PATCHES=(
	"${FILESDIR}"/${PN}-3.14.9-aliasing.patch
	"${FILESDIR}"/${PN}-3.14.9-close-on-exec.patch
	"${FILESDIR}"/${PN}-3.14.9-commfailure.patch
	"${FILESDIR}"/${PN}-3.14.9-fix-nologin.patch
	"${FILESDIR}"/${PN}-3.14.9-gapcmon.patch
	"${FILESDIR}"/${PN}-3.14.9-wall-on-mounted-usr.patch
	"${FILESDIR}"/${PN}-3.14.14-lto.patch
)

pkg_setup() {
	if use kernel_linux && use usb && linux_config_exists ; then
		check_extra_config
	fi
}

src_prepare() {
	default
	# skip this specific doc step as produced files never installed
	# this avoids calling the col command not available on musl based system.
	sed -i "/^SUBDIRS/ s/doc//g" Makefile || die
}

src_configure() {
	# We force the DISTNAME to gentoo so it will use gentoo's layout also
	# when installed on non-linux systems.
	local myeconfargs
	myeconfargs=(
		APCUPSD_MAIL="$(type -p mail)"
		--disable-gapcmon
		--enable-net
		--enable-pcnet
		--sbindir="/sbin"
		--sysconfdir="${EPREFIX}/etc/apcupsd"
		--with-distname="gentoo"
		--with-pwrfail-dir="${EPREFIX}/etc/apcupsd"
		--with-lock-dir="${EPREFIX}/run/apcupsd"
		--with-log-dir="${EPREFIX}/var/log"
		--with-nisip="127.0.0.1"
		--with-nis-port="3551"
		--with-pid-dir="${EPREFIX}/run/apcupsd"
		--with-upscable="$(usex usb usb smart)"
		--with-upstype="$(usex usb usb apcsmart)"
		$(use_enable cgi)
		$(use_enable modbus)
		$(use_enable snmp)
		$(use_enable usb)
		$(use_with cgi cgi-bin "${EPREFIX}/usr/libexec/${PN}/cgi-bin")
		$(usex modbus $(use_enable usb modbus-usb) "--disable-modbus-usb")
		$(usex usb "--without-serial-dev" "--with-serial-dev=/dev/ttyS0")
		$(usex usb "--with-dev=" "--with-dev=/dev/ttyS0")
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake VERBOSE="2"
}

src_install() {
	emake DESTDIR="${D}" VERBOSE="2" install

	rm "${ED}"/etc/init.d/apcupsd || die
	rm "${ED}"/etc/init.d/halt || die
	rm -r "${ED}"/usr/share/hal || die

	insinto /etc/apcupsd
	newins examples/safe.apccontrol safe.apccontrol

	doman doc/*.8 doc/*.5

	docinto html
	dodoc -r doc/manual/.
	einstalldocs

	newinitd "${FILESDIR}"/apcupsd.init apcupsd
	newinitd "${FILESDIR}"/apcupsd.powerfail.init-r1 apcupsd.powerfail

	systemd_dounit "${FILESDIR}"/apcupsd.service
	dotmpfiles "${FILESDIR}"/apcupsd-tmpfiles.conf

	# replace it with our udev rules if we're in Linux
	if use kernel_linux ; then
		udev_newrules "${FILESDIR}"/apcupsd-udev.rules 60-${PN}.rules
	fi

}

pkg_postinst() {
	use kernel_linux && udev_reload

	tmpfiles_process ${PN}-tmpfiles.conf

	if use cgi ; then
		elog "The cgi-bin directory for ${PN} is /usr/libexec/${PN}/cgi-bin."
		elog "Set up your ScriptAlias or symbolic links accordingly."
	fi

	elog ""
	elog "Since version 3.14.0 you can use multiple apcupsd instances to"
	elog "control more than one UPS in a single box with openRC."
	elog "To do this, create a link between /etc/init.d/apcupsd to a new"
	elog "/etc/init.d/apcupsd.something, and it will then load the"
	elog "configuration file at /etc/apcupsd/something.conf."
	elog ""

	elog 'If you want apcupsd to power off your UPS when it'
	elog 'shuts down your system in a power failure, you must'
	elog 'add apcupsd.powerfail to your shutdown runlevel:'
	elog ''
	elog ' \e[01m rc-update add apcupsd.powerfail shutdown \e[0m'
	elog ''

	if use kernel_linux; then
		elog "Starting from version 3.14.9-r1, ${PN} installs udev rules"
		elog "for persistent device naming. If you have multiple UPS"
		elog "connected to the machine, you can point them to the devices"
		elog "in /dev/apcups/by-id directory."
	fi
}

pkg_postrm() {
	use kernel_linux && udev_reload
}
