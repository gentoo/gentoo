# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit autotools eutils fdo-mime flag-o-matic multilib python-single-r1 systemd toolchain-funcs user

MY_P="${P/_}"
DESCRIPTION="Distribute compilation of C code across several machines on a network"
HOMEPAGE="http://distcc.org/"
SRC_URI="https://distcc.googlecode.com/files/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd"
IUSE="avahi crossdev gnome gssapi gtk hardened ipv6 selinux xinetd"

RESTRICT="test"

CDEPEND="${PYTHON_DEPS}
	dev-libs/popt
	avahi? ( >=net-dns/avahi-0.6[dbus] )
	gnome? (
		>=gnome-base/libgnome-2
		>=gnome-base/libgnomeui-2
		x11-libs/gtk+:2
		x11-libs/pango
	)
	gssapi? ( net-libs/libgssglue )
	gtk? ( x11-libs/gtk+:2 )"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	!net-misc/pump
	>=sys-devel/gcc-config-1.4.1
	selinux? ( sec-policy/selinux-distcc )
	xinetd? ( sys-apps/xinetd )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/${MY_P}"

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
	epatch "${FILESDIR}/${PN}-3.2_rc1-freedesktop.patch"
	# bug #258364
	epatch "${FILESDIR}/${PN}-3.2_rc1-python.patch"
	# for net-libs/libgssglue
	epatch "${FILESDIR}/${PN}-3.2_rc1-gssapi.patch"
	# SOCKSv5 support needed for Portage, bug #537616
	epatch "${FILESDIR}/${PN}-3.2_rc1-socks5.patch"
	epatch_user

	# Bugs #120001, #167844 and probably more. See patch for description.
	use hardened && epatch "${FILESDIR}/distcc-hardened.patch"

	sed -i \
		-e "/PATH/s:\$distcc_location:${EPREFIX}${DCCC_PATH}:" \
		-e "s:@PYTHON@:${EPYTHON}:" \
		pump.in || die "sed failed"

	sed \
		-e "s:@EPREFIX@:${EPREFIX:-/}:" \
		-e "s:@libdir@:/usr/$(get_libdir):" \
		"${FILESDIR}/3.2/distcc-config" > "${T}/distcc-config" || die

	eaclocal -Im4 --output=aclocal.m4
	eautoconf
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
		$(use_with gnome) \
		$(use_with gssapi auth) \
		${myconf}
}

src_install() {
	default
	python_optimize

	newinitd "${FILESDIR}/3.2/init" distccd
	systemd_dounit "${FILESDIR}/distccd.service"
	systemd_install_serviced "${FILESDIR}/distccd.service.conf"

	cp "${FILESDIR}/3.2/conf" "${T}/distccd" || die
	if use avahi; then
		cat >> "${T}/distccd" <<-EOF

		# Enable zeroconf support in distccd
		DISTCCD_OPTS="\${DISTCCD_OPTS} --zeroconf"
		EOF

		sed -i '/ExecStart/ s|$| --zeroconf|' "${ED}"/usr/lib/systemd/system/distccd.service || die
	fi
	doconfd "${T}/distccd" || die

	cat > "${T}/02distcc" <<-EOF
	# This file is managed by distcc-config; use it to change these settings.
	# DISTCC_LOG and DISTCC_DIR should not be set.
	DISTCC_VERBOSE="${DISTCC_VERBOSE:-0}"
	DISTCC_FALLBACK="${DISTCC_FALLBACK:-1}"
	DISTCC_SAVE_TEMPS="${DISTCC_SAVE_TEMPS:-0}"
	DISTCC_TCP_CORK="${DISTCC_TCP_CORK}"
	DISTCC_SSH="${DISTCC_SSH}"
	UNCACHED_ERR_FD="${UNCACHED_ERR_FD}"
	DISTCC_ENABLE_DISCREPANCY_EMAIL="${DISTCC_ENABLE_DISCREPANCY_EMAIL}"
	DCC_EMAILLOG_WHOM_TO_BLAME="${DCC_EMAILLOG_WHOM_TO_BLAME}"
	EOF
	doenvd "${T}/02distcc" || die

	keepdir "${DCCC_PATH}" || die

	dobin "${T}/distcc-config" || die

	# create the distccd pid directory
	keepdir /var/run/distccd || die
	fowners distcc:daemon /var/run/distccd || die

	if use gnome || use gtk; then
		einfo "Renaming /usr/bin/distccmon-gnome to /usr/bin/distccmon-gui"
		einfo "This is to have a little sensability in naming schemes between distccmon programs"
		mv "${ED}/usr/bin/distccmon-gnome" "${ED}/usr/bin/distccmon-gui" || die
		dosym distccmon-gui /usr/bin/distccmon-gnome || die
	fi

	if use xinetd; then
		insinto /etc/xinetd.d || die
		newins "doc/example/xinetd" distcc || die
	fi

	rm -r "${ED}/etc/default" || die
	rm "${ED}/etc/distcc/clients.allow" || die
	rm "${ED}/etc/distcc/commands.allow.sh" || die
}

pkg_postinst() {
	if [ -x "${EPREFIX}/usr/bin/distcc-config" ] ; then
		if use crossdev; then
			"${EPREFIX}/usr/bin/distcc-config" --update-masquerade-with-crossdev
		else
			"${EPREFIX}/usr/bin/distcc-config" --update-masquerade
		fi
	fi

	use gnome && fdo-mime_desktop_database_update

	elog
	elog "Tips on using distcc with Gentoo can be found at"
	elog "https://wiki.gentoo.org/wiki/Distcc"
	elog
	elog "How to use pump mode with Gentoo:"
	elog "# distcc-config --set-hosts \"foo,cpp,lzo bar,cpp,lzo baz,cpp,lzo\""
	elog "# echo 'FEATURES=\"\${FEATURES} distcc distcc-pump\"' >> /etc/portage/make.conf"
	elog "# emerge -u world"
	elog
	elog "To use the distccmon programs with Gentoo you should use this command:"
	elog "# DISTCC_DIR=\"${DISTCC_DIR:-${BUILD_PREFIX}/.distcc}\" distccmon-text 5"

	if use gnome || use gtk; then
		elog "Or:"
		elog "# DISTCC_DIR=\"${DISTCC_DIR:-${BUILD_PREFIX}/.distcc}\" distccmon-gnome"
	fi

	elog
	elog "***SECURITY NOTICE***"
	elog "If you are upgrading distcc please make sure to run etc-update to"
	elog "update your /etc/conf.d/distccd and /etc/init.d/distccd files with"
	elog "added security precautions (the --listen and --allow directives)"
	elog
}

pkg_postrm() {
	# delete the masquerade directory
	if [ ! -f "${EPREFIX}/usr/bin/distcc" ] ; then
		einfo "Remove masquerade symbolic links."
		rm "${EPREFIX}${DCCC_PATH}/"*{cc,c++,gcc,g++}
		rmdir "${EPREFIX}${DCCC_PATH}"
	fi

	use gnome && fdo-mime_desktop_database_update
}
