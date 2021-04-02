# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit linux-info flag-o-matic systemd udev tmpfiles

DESCRIPTION="APC UPS daemon with integrated tcp/ip remote shutdown"
HOMEPAGE="http://www.apcupsd.org/"
SRC_URI="mirror://sourceforge/apcupsd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="snmp +usb +modbus cgi gnome kernel_linux"

DEPEND=">=sys-apps/util-linux-2.23[tty-helpers(-)]
	cgi? ( >=media-libs/gd-1.8.4 )
	modbus? ( usb? ( virtual/libusb:0 ) )
	gnome? (
		>=x11-libs/gtk+-2.4.0:2
		dev-libs/glib:2
		>=gnome-base/gconf-2.0
	)
	snmp? ( >=net-analyzer/net-snmp-5.7.2 )"

RDEPEND="${DEPEND}
	virtual/mailx"

CONFIG_CHECK="~USB_HIDDEV ~HIDRAW"
ERROR_USB_HIDDEV="CONFIG_USB_HIDDEV:	needed to access USB-attached UPSes"
ERROR_HIDRAW="CONFIG_HIDRAW:		needed to access USB-attached UPSes"

DOCS=( ChangeLog ReleaseNotes )
HTML_DOCS=( doc/manual )

PATCHES=(
	"${FILESDIR}"/${PN}-3.14.9-aliasing.patch
	"${FILESDIR}"/${PN}-3.14.9-close-on-exec.patch
	"${FILESDIR}"/${PN}-3.14.9-commfailure.patch
	"${FILESDIR}"/${PN}-3.14.9-fix-nologin.patch
	"${FILESDIR}"/${PN}-3.14.9-gapcmon.patch
	"${FILESDIR}"/${PN}-3.14.9-wall-on-mounted-usr.patch
)

pkg_setup() {
	if use kernel_linux && use usb && linux_config_exists ; then
		check_extra_config
	fi
}

src_configure() {
	local myconf

	use cgi && myconf="${myconf} --enable-cgi --with-cgi-bin=/usr/libexec/${PN}/cgi-bin"

	if use usb ; then
		myconf="${myconf} --with-upstype=usb --with-upscable=usb --enable-usb --with-dev="
		use modbus && myconf="${myconf} --enable-modbus-usb"
	else
		myconf="${myconf} --with-upstype=apcsmart --with-upscable=smart --disable-usb"
		use modbus || myconf="${myconf} --disable-modbus"
	fi

	# We force the DISTNAME to gentoo so it will use gentoo's layout also
	# when installed on non-linux systems.
	econf \
		--sbindir=/sbin \
		--sysconfdir=/etc/apcupsd \
		--with-pwrfail-dir=/etc/apcupsd \
		--with-lock-dir=/run/apcupsd \
		--with-pid-dir=/run/apcupsd \
		--with-log-dir=/var/log \
		--with-nis-port=3551 \
		--enable-net --enable-pcnet \
		--with-distname=gentoo \
		$(use_enable snmp) \
		$(use_enable gnome gapcmon) \
		${myconf} \
		APCUPSD_MAIL=$(type -p mail)
}

src_compile() {
	# Workaround for bug #280674; upstream should really just provide
	# the text files in the distribution, but I wouldn't count on them
	# doing that anytime soon.
	MANPAGER=$(type -p cat) \
		emake VERBOSE=2
}

src_install() {
	emake DESTDIR="${D}" VERBOSE=2 install
	rm "${ED}"/etc/init.d/halt || die

	insinto /etc/apcupsd
	newins examples/safe.apccontrol safe.apccontrol
	doins "${FILESDIR}"/apcupsd.conf

	doman doc/*.8 doc/*.5

	einstalldocs

	rm "${ED}"/etc/init.d/apcupsd || die
	newinitd "${FILESDIR}/${PN}.init" "${PN}"
	newinitd "${FILESDIR}/${PN}.powerfail.init" "${PN}".powerfail

	systemd_dounit "${FILESDIR}"/${PN}.service
	dotmpfiles "${FILESDIR}"/${PN}-tmpfiles.conf

	# remove hal settings, we don't really want to have it still around.
	rm -r "${D}"/usr/share/hal || die

	# replace it with our udev rules if we're in Linux
	if use kernel_linux ; then
		udev_newrules "${FILESDIR}"/apcupsd-udev.rules 60-${PN}.rules
	fi

}

pkg_postinst() {
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
