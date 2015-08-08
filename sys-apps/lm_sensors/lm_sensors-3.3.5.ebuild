# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils linux-info multilib systemd toolchain-funcs

DESCRIPTION="Hardware Monitoring user-space utilities"
HOMEPAGE="http://www.lm-sensors.org/"
SRC_URI="http://dl.lm-sensors.org/lm-sensors/releases/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha ~amd64 arm ~mips ~ppc ~ppc64 sparc x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE="sensord static-libs"

RDEPEND="
	dev-lang/perl
	sensord? (
		net-analyzer/rrdtool
		virtual/logger
		)"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

CONFIG_CHECK="~HWMON ~I2C_CHARDEV ~I2C"
WARNING_HWMON="${PN} requires CONFIG_HWMON to be enabled for use."
WARNING_I2C_CHARDEV="sensors-detect requires CONFIG_I2C_CHARDEV to be enabled."
WARNING_I2C="${PN} requires CONFIG_I2C to be enabled for most sensors."

src_prepare() {
	epatch "${FILESDIR}"/${P}-sensors-detect-gentoo.patch

	use sensord && { sed -i -e 's:^#\(PROG_EXTRA.*\):\1:' Makefile || die; }

	# Respect LDFLAGS
	sed -i -e 's/\$(LIBDIR)$/\$(LIBDIR) \$(LDFLAGS)/g' Makefile || die

	# Fix shipped unit file paths
	sed -i -e 's:\(^EnvironmentFile=\).*:\1/etc/conf.d/lm_sensors:' \
		prog/init/lm_sensors.service || die

	use static-libs || { sed -i -e '/^BUILD_STATIC_LIB/d' Makefile || die; }
}

src_compile() {
	einfo
	einfo "You may safely ignore any errors from compilation"
	einfo "that contain \"No such file or directory\" references."
	einfo

	emake CC="$(tc-getCC)"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		MANDIR="${EPREFIX}/usr/share/man" \
		ETCDIR="${EPREFIX}/etc" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		install

	newinitd "${FILESDIR}"/${PN}-3-init.d ${PN}
	systemd_dounit prog/init/lm_sensors.service

	newinitd "${FILESDIR}"/fancontrol-init.d-2 fancontrol
	systemd_dounit "${FILESDIR}"/fancontrol.service

	if use sensord; then
		newconfd "${FILESDIR}"/sensord-conf.d sensord
		newinitd "${FILESDIR}"/sensord-4-init.d sensord
		systemd_dounit "${FILESDIR}"/sensord.service
	fi

	dodoc CHANGES CONTRIBUTORS INSTALL README \
		doc/{donations,fancontrol.txt,fan-divisors,libsensors-API.txt,progs,temperature-sensors,vid}

	docinto developers
	dodoc doc/developers/applications
}

pkg_postinst() {
	echo
	elog "Please run \`/usr/sbin/sensors-detect' in order to setup"
	elog "/etc/conf.d/${PN}."
	echo
	elog "/etc/conf.d/${PN} is vital to the init-script."
	elog "Please make sure you also add ${PN} to the desired"
	elog "runlevel. Otherwise your I2C modules won't get loaded"
	elog "on the next startup."
	echo
	elog "You will also need to run the above command if you're upgrading from"
	elog "<=${PN}-2, as the needed entries in /etc/conf.d/${PN} has"
	elog "changed."
	echo
	elog "Be warned, the probing of hardware in your system performed by"
	elog "sensors-detect could freeze your system. Also make sure you read"
	elog "the documentation before running ${PN} on IBM ThinkPads."
	echo
	elog "Also make sure you have read:"
	elog "http://www.lm-sensors.org/wiki/FAQ/Chapter3#Mysensorshavestoppedworkinginkernel2.6.31"
	echo
	elog "Please refer to the ${PN} documentation for more information."
	elog "(http://www.lm-sensors.org/wiki/Documentation)"
	echo
}
