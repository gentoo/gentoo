# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit autotools flag-o-matic python-single-r1 systemd \
	toolchain-funcs user xdg-utils prefix

DESCRIPTION="Distribute compilation of C code across several machines on a network"
HOMEPAGE="https://github.com/distcc/distcc"
SRC_URI="https://github.com/distcc/distcc/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86"
IUSE="gssapi gtk hardened ipv6 selinux xinetd zeroconf"

CDEPEND="${PYTHON_DEPS}
	dev-libs/popt
	gssapi? ( net-libs/libgssglue )
	gtk? ( x11-libs/gtk+:2 )
	zeroconf? ( >=net-dns/avahi-0.6[dbus] )
"
DEPEND="${CDEPEND}
	sys-devel/autoconf-archive
	sys-libs/binutils-libs
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	dev-util/shadowman
	>=sys-devel/gcc-config-1.4.1
	selinux? ( sec-policy/selinux-distcc )
	xinetd? ( sys-apps/xinetd )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

pkg_setup() {
	enewuser distcc 240 -1 -1 daemon
	python-single-r1_pkg_setup
}

src_prepare() {
	eapply "${FILESDIR}/${PN}-3.0-xinetd.patch"
	# bug #255188
	eapply "${FILESDIR}/${PN}-3.3.2-freedesktop.patch"
	# SOCKSv5 support needed for Portage, bug #537616
	eapply "${FILESDIR}/${PN}-3.2_rc1-socks5.patch"
	# backport py3.8 fixes
	eapply "${FILESDIR}/${P}-py38.patch"
	eapply_user

	# Bugs #120001, #167844 and probably more. See patch for description.
	use hardened && eapply "${FILESDIR}/distcc-hardened.patch"

	sed -i \
		-e "/PATH/s:\$distcc_location:${EPREFIX}/usr/lib/distcc/bin:" \
		-e "s:@PYTHON@:${EPYTHON}:" \
		pump.in || die "sed failed"

	sed \
		-e "s:@EPREFIX@:${EPREFIX:-/}:" \
		-e "s:@libdir@:/usr/lib:" \
		"${FILESDIR}/distcc-config" > "${T}/distcc-config" || die

	# TODO: gdb tests fail due to gdb failing to find .c file
	sed -i -e '/Gdb.*Case,/d' test/testdistcc.py || die

	hprefixify update-distcc-symlinks.py src/{serve,daemon}.c
	python_fix_shebang update-distcc-symlinks.py "${T}/distcc-config"
	eautoreconf
}

src_configure() {
	local myconf=(
		--disable-Werror
		--libdir=/usr/lib
		$(use_enable ipv6 rfc2553)
		$(use_with gtk)
		--without-gnome
		$(use_with gssapi auth)
		$(use_with zeroconf avahi)
	)

	econf "${myconf[@]}"
}

src_test() {
	# sandbox breaks some tests, and hangs some too
	# retest once #590084 is fixed
	local -x SANDBOX_ON=0
	emake -j1 check
}

src_install() {
	# override GZIP_BIN to stop it from compressing manpages
	emake DESTDIR="${D}" GZIP_BIN=false install
	python_optimize

	newinitd "${FILESDIR}/distccd.initd" distccd
	systemd_newunit "${FILESDIR}/distccd.service-1" distccd.service
	systemd_install_serviced "${FILESDIR}/distccd.service.conf"

	cp "${FILESDIR}/distccd.confd" "${T}/distccd" || die
	if use zeroconf; then
		cat >> "${T}/distccd" <<-EOF || die

		# Enable zeroconf support in distccd
		DISTCCD_OPTS="\${DISTCCD_OPTS} --zeroconf"
		EOF

		sed -i '/ExecStart/ s|$| --zeroconf|' "${D}$(systemd_get_systemunitdir)"/distccd.service || die
	fi
	doconfd "${T}/distccd"

	newenvd - 02distcc <<-EOF || die
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

	keepdir /usr/lib/distcc

	dobin "${T}/distcc-config"

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

	insinto /usr/share/shadowman/tools
	newins - distcc <<<"${EPREFIX}/usr/lib/distcc/bin"
	newins - distccd <<<"${EPREFIX}/usr/lib/distcc"

	rm -r "${ED}/etc/default" || die
	rm "${ED}/etc/distcc/clients.allow" || die
	rm "${ED}/etc/distcc/commands.allow.sh" || die
}

pkg_postinst() {
	# remove the old paths when switching from libXX to lib
	if [[ $(get_libdir) != lib && ${SYMLINK_LIB} != yes && \
			-d ${EROOT%/}/usr/$(get_libdir)/distcc ]]; then
		rm -r -f "${EROOT%/}/usr/$(get_libdir)/distcc" || die
	fi

	if [[ ${ROOT} == / ]]; then
		eselect compiler-shadow update distcc
		eselect compiler-shadow update distccd
	fi

	elog
	elog "Tips on using distcc with Gentoo can be found at"
	elog "https://wiki.gentoo.org/wiki/Distcc"
	elog
	elog "distcc-pump is known to cause breakage with multiple packages."
	elog "Do NOT enable it globally."
	elog
	elog "To use the distccmon programs with Gentoo you should use this command:"
	elog "# DISTCC_DIR=\"${DISTCC_DIR:-${BUILD_PREFIX}/.distcc}\" distccmon-text 5"

	if use gtk; then
		elog "Or:"
		elog "# DISTCC_DIR=\"${DISTCC_DIR:-${BUILD_PREFIX}/.distcc}\" distccmon-gnome"
	fi

	elog
	elog "***SECURITY NOTICE***"
	elog "Since distcc-3.3, whitelist is used for what distccd could execute. The whilelist"
	elog "has been generated by compiler-shadow distccd.  To revert to the old behavior, "
	elog "you need to pass --make-me-a-botnet to distccd in /etc/conf.d/distccd."
	elog "Cf. https://github.com/distcc/distcc/pull/243."
}

pkg_prerm() {
	if [[ -z ${REPLACED_BY_VERSION} && ${ROOT} == / ]]; then
		eselect compiler-shadow remove distcc
	fi
}
