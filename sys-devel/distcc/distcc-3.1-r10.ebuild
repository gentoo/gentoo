# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils fdo-mime flag-o-matic multilib python-single-r1 systemd toolchain-funcs user

DESCRIPTION="Distribute compilation of C code across several machines on a network"
HOMEPAGE="http://distcc.org/"
SRC_URI="https://distcc.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE="avahi gtk hardened ipv6 selinux xinetd"

RESTRICT="test"

CDEPEND="${PYTHON_DEPS}
	dev-libs/popt
	avahi? ( >=net-dns/avahi-0.6[dbus] )
	gtk? ( x11-libs/gtk+:2 )"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	!net-misc/pump
	>=sys-devel/gcc-config-1.4.1
	selinux? ( sec-policy/selinux-distcc )
	xinetd? ( sys-apps/xinetd )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DISTCC_LOG=""
DCCC_PATH="/usr/$(get_libdir)/distcc/bin"
DISTCC_VERBOSE="0"

pkg_setup() {
	enewuser distcc 240 -1 -1 daemon
	python-single-r1_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-3.0-xinetd.patch"
	# bug #253786
	epatch "${FILESDIR}/${PN}-3.0-fix-fortify.patch"
	# bug #255188
	epatch "${FILESDIR}/${P}-freedesktop.patch"
	# bug #258364
	epatch "${FILESDIR}/${P}-python.patch"
	# bug #351979
	epatch "${FILESDIR}/${P}-argc-fix.patch"
	epatch_user

	sed -i -e "/PATH/s:\$distcc_location:${DCCC_PATH}:" pump.in || die

	# Bugs #120001, #167844 and probably more. See patch for description.
	use hardened && epatch "${FILESDIR}/distcc-hardened.patch"
}

src_configure() {
	local myconf="--disable-Werror --with-docdir=/usr/share/doc/${PF}"
	# More legacy stuff?
	[ "$(gcc-major-version)" = "2" ] && filter-lfs-flags

	# --disable-rfc2553 b0rked, bug #254176
	use ipv6 && myconf="${myconf} --enable-rfc2553"

	econf \
		$(use_with avahi) \
		$(use_with gtk) \
		${myconf}
}

src_install() {
	# In rare cases, parallel make install failed
	MAKEOPTS+=" -j1"
	default

	dobin "${FILESDIR}/3.0/distcc-config"

	newinitd "${FILESDIR}/${PV}/init" distccd
	systemd_dounit "${FILESDIR}/distccd.service"
	systemd_install_serviced "${FILESDIR}/distccd.service.conf"

	cp "${FILESDIR}/3.1/conf" "${T}/distccd" || die
	if use avahi; then
		cat >> "${T}/distccd" <<-EOF

		# Enable zeroconf support in distccd
		DISTCCD_OPTS="\${DISTCCD_OPTS} --zeroconf"
		EOF

		sed -i '/ExecStart/ s|$| --zeroconf|' "${ED}"/usr/lib/systemd/system/distccd.service || die
	fi
	doconfd "${T}/distccd"

	cat > "${T}/02distcc" <<-EOF
	# This file is managed by distcc-config; use it to change these settings.
	DISTCC_LOG="${DISTCC_LOG}"
	DCCC_PATH="${DCCC_PATH}"
	DISTCC_VERBOSE="${DISTCC_VERBOSE}"
	EOF
	doenvd "${T}/02distcc"

	# create the masquerade directory
	dodir "${DCCC_PATH}"
	for f in cc c++ gcc g++; do
		dosym /usr/bin/distcc "${DCCC_PATH}/${f}"
		if [ "${f}" != "cc" ]; then
			dosym /usr/bin/distcc "${DCCC_PATH}/${CTARGET:-${CHOST}}-${f}"
		fi
	done

	# create the distccd pid directory
	keepdir /var/run/distccd
	fowners distcc:daemon /var/run/distccd

	if use gtk; then
		einfo "Renaming /usr/bin/distccmon-gnome to /usr/bin/distccmon-gui"
		einfo "This is to have a little sensability in naming schemes between distccmon programs"
		mv "${ED}/usr/bin/distccmon-gnome" "${ED}/usr/bin/distccmon-gui" || die
		dosym distccmon-gui /usr/bin/distccmon-gnome
	fi

	if use xinetd; then
		insinto /etc/xinetd.d
		newins "doc/example/xinetd" distcc
	fi

	rm -rf "${D}/etc/default" || die
	rm -f "${D}/etc/distcc/clients.allow" || die
	rm -f "${D}/etc/distcc/commands.allow.sh" || die

	python_fix_shebang "${ED}"
	python_optimize "${ED}"/$(python_get_sitedir)
}

pkg_postinst() {
	use gtk && fdo-mime_desktop_database_update

	if use ipv6; then
		elog
		elog "IPv6 is not supported yet by ${P}."
	fi
	elog
	elog "Tips on using distcc with Gentoo can be found at"
	elog "https://www.gentoo.org/doc/en/distcc.xml"
	elog
	elog "How to use pump mode with Gentoo:"
	elog "# distcc-config --set-hosts \"foo,cpp,lzo bar,cpp,lzo baz,cpp,lzo\""
	elog "# pump emerge -u world"
	elog
	elog "To use the distccmon programs with Gentoo you should use this command:"
	elog "# DISTCC_DIR=\"${DISTCC_DIR}\" distccmon-text 5"

	if use gtk; then
		elog "Or:"
		elog "# DISTCC_DIR=\"${DISTCC_DIR}\" distccmon-gnome"
	fi

	elog
	elog "***SECURITY NOTICE***"
	elog "If you are upgrading distcc please make sure to run etc-update to"
	elog "update your /etc/conf.d/distccd and /etc/init.d/distccd files with"
	elog "added security precautions (the --listen and --allow directives)"
	elog
}

pkg_postrm() {
	use gtk && fdo-mime_desktop_database_update
}
