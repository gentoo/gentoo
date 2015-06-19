# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/apcupsd/apcupsd-3.14.8-r2.ebuild,v 1.6 2014/06/11 07:50:39 pinkbyte Exp $

EAPI=3

inherit eutils linux-info flag-o-matic systemd

DESCRIPTION="APC UPS daemon with integrated tcp/ip remote shutdown"
HOMEPAGE="http://www.apcupsd.org/"
SRC_URI="mirror://sourceforge/apcupsd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE="snmp +usb cgi nls gnome kernel_linux"

DEPEND="
	||	( >=sys-apps/util-linux-2.23[tty-helpers]
		  <=sys-apps/sysvinit-2.88-r4
		  sys-freebsd/freebsd-ubin
		)
	cgi? ( >=media-libs/gd-1.8.4 )
	nls? ( sys-devel/gettext )
	snmp? ( net-analyzer/net-snmp )
	gnome? ( >=x11-libs/gtk+-2.4.0:2
		dev-libs/glib:2
		>=gnome-base/gconf-2.0 )"
RDEPEND="${DEPEND}
	virtual/mailx"

CONFIG_CHECK="~USB_HIDDEV ~HIDRAW"
ERROR_USB_HIDDEV="CONFIG_USB_HIDDEV:	needed to access USB-attached UPSes"
ERROR_HIDRAW="CONFIG_HIDRAW:		needed to access USB-attached UPSes"

pkg_setup() {
	if use kernel_linux && use usb && linux_config_exists; then
		check_extra_config
	fi
}

src_configure() {
	local myconf
	use cgi && myconf="${myconf} --enable-cgi --with-cgi-bin=/usr/libexec/${PN}/cgi-bin"
	if use usb; then
		myconf="${myconf} --with-upstype=usb --with-upscable=usb --enable-usb --with-dev= "
	else
		myconf="${myconf} --with-upstype=apcsmart --with-upscable=smart --disable-usb"
	fi

	append-flags -fno-strict-aliasing

	# We force the DISTNAME to gentoo so it will use gentoo's layout also
	# when installed on non-linux systems.
	econf \
		--sbindir=/sbin \
		--sysconfdir=/etc/apcupsd \
		--with-pwrfail-dir=/etc/apcupsd \
		--with-lock-dir=/var/lock \
		--with-pid-dir=/var/run \
		--with-log-dir=/var/log \
		--with-nis-port=3551 \
		--enable-net --enable-pcnet \
		--with-distname=gentoo \
		$(use_enable snmp net-snmp) \
		$(use_enable gnome gapcmon) \
		${myconf} \
		APCUPSD_MAIL=/bin/mail \
		|| die "econf failed"
}

src_compile() {
	# Workaround for bug #280674; upstream should really just provide
	# the text files in the distribution, but I wouldn't count on them
	# doing that anytime soon.
	MANPAGER=$(type -p cat) \
		emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "installed failed"
	rm -f "${D}"/etc/init.d/halt

	insinto /etc/apcupsd
	newins examples/safe.apccontrol safe.apccontrol

	dodoc ChangeLog* ReleaseNotes
	doman doc/*.8 doc/*.5 || die "doman failed"

	dohtml -r doc/manual/* || die "dodoc failed"

	rm "${D}"/etc/init.d/apcupsd
	newinitd "${FILESDIR}/${PN}.init.2a" "${PN}" || die "newinitd failed"
	systemd_dounit "${FILESDIR}"/${PN}.service
	systemd_dotmpfilesd "${FILESDIR}"/${PN}-tmpfiles.conf

	if has_version sys-apps/openrc; then
		newinitd "${FILESDIR}/${PN}.powerfail.init" "${PN}".powerfail || die "newinitd failed"
	fi

	# remove hal settings, we don't really want to have it around still.
	rm -r "${D}"/usr/share/hal

	# Without this it'll crash at startup. When merging in ROOT= this
	# won't be created by default, so we want to make sure we got it!
	keepdir /var/lock
	fowners root:uucp /var/lock
	fperms 0775 /var/lock
}

pkg_postinst() {
	if use cgi; then
		elog "The cgi-bin directory for ${PN} is /usr/libexec/${PN}/cgi-bin."
		elog "Set up your ScriptAlias or symbolic links accordingly."
	fi

	elog ""
	elog "Since version 3.14.0 you can use multiple apcupsd instances to"
	elog "control more than one UPS in a single box."
	elog "To do this, create a link between /etc/init.d/apcupsd to a new"
	elog "/etc/init.d/apcupsd.something, and it will then load the"
	elog "configuration file at /etc/apcupsd/something.conf."
	elog ""

	if [ -d "${ROOT}"/etc/runlevels/shutdown -a \
			! -e "${ROOT}"/etc/runlevels/shutdown/"${PN}".powerfail ] ; then
		elog 'If you want apcupsd to power off your UPS when it'
		elog 'shuts down your system in a power failure, you must'
		elog 'add apcupsd.powerfail to your shutdown runlevel:'
		elog ''
		elog ' \e[01m rc-update add apcupsd.powerfail shutdown \e[0m'
		elog ''
	fi
}
