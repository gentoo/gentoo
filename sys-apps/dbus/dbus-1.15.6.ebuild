# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Be careful with packaging odd-version-number branches!
# After >1.15, we should at least keep stable as an upstream stable branch,
# possibly even ~arch too, given the note about security releases on their website.
# See https://www.freedesktop.org/wiki/Software/dbus/#download.

PYTHON_COMPAT=( python3_{10..12} )
TMPFILES_OPTIONAL=1

# As of 1.15.6, the Meson build system is now recommended upstream, but we
# can't use it because our elogind patch needs rebasing and submission upstream.
# See bug #599494.
inherit autotools flag-o-matic linux-info python-any-r1 readme.gentoo-r1 systemd tmpfiles virtualx multilib-minimal

DESCRIPTION="A message bus system, a simple way for applications to talk to each other"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/dbus/"
SRC_URI="https://dbus.freedesktop.org/releases/dbus/${P}.tar.xz"

LICENSE="|| ( AFL-2.1 GPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="debug doc elogind selinux static-libs systemd test valgrind X"
RESTRICT="!test? ( test )"

REQUIRED_USE="?? ( elogind systemd )"

BDEPEND="
	acct-user/messagebus
	app-text/xmlto
	app-text/docbook-xml-dtd:4.4
	sys-devel/autoconf-archive
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
COMMON_DEPEND="
	>=dev-libs/expat-2.1.0
	elogind? ( sys-auth/elogind )
	selinux? (
		sys-process/audit
		sys-libs/libselinux
	)
	systemd? ( sys-apps/systemd:0= )
	X? (
		x11-libs/libX11
		x11-libs/libXt
	)
"
DEPEND="${COMMON_DEPEND}
	dev-libs/expat
	test? (
		${PYTHON_DEPS}
		>=dev-libs/glib-2.40:2
	)
	valgrind? ( >=dev-util/valgrind-3.6 )
	X? ( x11-base/xorg-proto )
"
RDEPEND="${COMMON_DEPEND}
	acct-user/messagebus
	selinux? ( sec-policy/selinux-dbus )
	systemd? ( virtual/tmpfiles )
"

DOC_CONTENTS="
	Some applications require a session bus in addition to the system
	bus. Please see \`man dbus-launch\` for more information.
"

# out of sources build dir for make check
TBD="${WORKDIR}/${P}-tests-build"

PATCHES=(
	"${FILESDIR}/dbus-1.15.0-enable-elogind.patch"
	"${FILESDIR}/dbus-1.15.0-daemon-optional.patch" # bug #653136
)

pkg_setup() {
	use test && python-any-r1_pkg_setup

	if use kernel_linux; then
		CONFIG_CHECK="~EPOLL"
		linux-info_pkg_setup
	fi
}

src_prepare() {
	default

	if [[ ${CHOST} == *-solaris* ]]; then
		# fix standards conflict, due to gcc being c99 by default nowadays
		sed -i \
			-e 's/_XOPEN_SOURCE=500/_XOPEN_SOURCE=600/' \
			configure.ac || die
	fi

	# required for bug #263909, cross-compile so don't remove eautoreconf
	eautoreconf
}

src_configure() {
	local rundir=$(usex kernel_linux /run /var/run)

	sed -e "s;@rundir@;${EPREFIX}${rundir};g" "${FILESDIR}"/dbus.initd.in \
		> "${T}"/dbus.initd || die

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local docconf myconf testconf

	# so we can get backtraces from apps
	case ${CHOST} in
		*-mingw*)
			# error: unrecognized command line option '-rdynamic', bug #488036
			;;
		*)
			append-flags -rdynamic
			;;
	esac

	# libaudit is *only* used in DBus wrt SELinux support, so disable it, if
	# not on an SELinux profile.
	myconf=(
		--localstatedir="${EPREFIX}/var"
		--runstatedir="${EPREFIX}${rundir}"
		$(use_enable static-libs static)
		$(use_enable debug verbose-mode)
		--disable-asserts
		--disable-checks
		$(use_enable selinux)
		$(use_enable selinux libaudit)
		--disable-apparmor
		$(use_enable kernel_linux inotify)
		--disable-kqueue
		$(use_enable elogind)
		$(use_enable systemd)
		$(use_enable systemd user-session)
		--disable-embedded-tests
		--disable-modular-tests
		$(use_enable debug stats)
		--with-session-socket-dir="${EPREFIX}"/tmp
		--with-system-pid-file="${EPREFIX}${rundir}"/dbus.pid
		--with-system-socket="${EPREFIX}${rundir}"/dbus/system_bus_socket
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		--with-systemduserunitdir="$(systemd_get_userunitdir)"
		--with-dbus-user=messagebus
		$(multilib_native_use_with valgrind)
		$(use_with X x)
	)

	if [[ ${CHOST} == *-darwin* ]]; then
		myconf+=(
			--enable-launchd
			--with-launchd-agent-dir="${EPREFIX}"/Library/LaunchAgents
		)
	fi

	if multilib_is_native_abi; then
		docconf=(
			--enable-xml-docs
			$(use_enable doc doxygen-docs)
		)
	else
		docconf=(
			--disable-xml-docs
			--disable-doxygen-docs
		)
		myconf+=(
			--disable-daemon
			--disable-selinux
			--disable-libaudit
			--disable-elogind
			--disable-systemd
			--without-x
		)
	fi

	einfo "Running configure in ${BUILD_DIR}"
	ECONF_SOURCE="${S}" econf "${myconf[@]}" "${docconf[@]}"

	if multilib_is_native_abi && use test; then
		mkdir "${TBD}" || die
		cd "${TBD}" || die
		testconf=(
			$(use_enable test asserts)
			$(use_enable test checks)
			$(use_enable test embedded-tests)
			$(use_enable test stats)
			$(has_version dev-libs/dbus-glib && echo --enable-modular-tests)
		)
		einfo "Running configure in ${TBD}"
		ECONF_SOURCE="${S}" econf "${myconf[@]}" "${testconf[@]}"
	fi
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		# After the compile, it uses a selinuxfs interface to
		# check if the SELinux policy has the right support
		use selinux && addwrite /selinux/access

		einfo "Running make in ${BUILD_DIR}"
		emake

		if use test; then
			einfo "Running make in ${TBD}"
			emake -C "${TBD}"
		fi
	else
		emake -C dbus libdbus-1.la
	fi
}

src_test() {
	# DBUS_TEST_MALLOC_FAILURES=0 to avoid huge test logs
	# https://gitlab.freedesktop.org/dbus/dbus/-/blob/master/CONTRIBUTING.md#L231
	DBUS_TEST_MALLOC_FAILURES=0 DBUS_VERBOSE=1 virtx emake -j1 -C "${TBD}" check

}

multilib_src_install() {
	if multilib_is_native_abi; then
		emake DESTDIR="${D}" install
	else
		emake DESTDIR="${D}" install-pkgconfigDATA install-cmakeconfigDATA
		emake DESTDIR="${D}" -C dbus \
			install-libLTLIBRARIES install-dbusincludeHEADERS \
			install-nodist_dbusarchincludeHEADERS
	fi
}

multilib_src_install_all() {
	newinitd "${T}"/dbus.initd dbus

	if use X; then
		# dbus X session script (bug #77504)
		# turns out to only work for GDM (and startx). has been merged into
		# other desktop (kdm and such scripts)
		exeinto /etc/X11/xinit/xinitrc.d
		newexe "${FILESDIR}"/80-dbus-r1 80-dbus
	fi

	# Needs to exist for dbus sessions to launch
	keepdir /usr/share/dbus-1/services
	keepdir /etc/dbus-1/{session,system}.d
	# machine-id symlink from pkg_postinst()
	keepdir /var/lib/dbus
	# Let the init script create the /var/run/dbus directory
	rm -rf "${ED}"/{,var/}run

	# bug #761763
	rm -rf "${ED}"/usr/lib/sysusers.d

	dodoc AUTHORS NEWS README doc/TODO
	readme.gentoo_create_doc

	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	readme.gentoo_print_elog

	if use systemd; then
		tmpfiles_process dbus.conf
	fi

	# Ensure unique id is generated and put it in /etc wrt bug #370451 but symlink
	# for DBUS_MACHINE_UUID_FILE (see tools/dbus-launch.c) and reverse
	# dependencies with hardcoded paths (although the known ones got fixed already)
	# TODO: should be safe to remove at least the ln because of the above tmpfiles_process?
	dbus-uuidgen --ensure="${EROOT}"/etc/machine-id
	ln -sf "${EPREFIX}"/etc/machine-id "${EROOT}"/var/lib/dbus/machine-id

	if [[ ${CHOST} == *-darwin* ]]; then
		local plist="org.freedesktop.dbus-session.plist"
		elog
		elog
		elog "For MacOS/Darwin we now ship launchd support for dbus."
		elog "This enables autolaunch of dbus at session login and makes"
		elog "dbus usable under MacOS/Darwin."
		elog
		elog "The launchd plist file ${plist} has been"
		elog "installed in ${EPREFIX}/Library/LaunchAgents."
		elog "For it to be used, you will have to do all of the following:"
		elog " + cd ~/Library/LaunchAgents"
		elog " + ln -s ${EPREFIX}/Library/LaunchAgents/${plist}"
		elog " + logout and log back in"
		elog
		elog "If your application needs a proper DBUS_SESSION_BUS_ADDRESS"
		elog "specified and refused to start otherwise, then export the"
		elog "the following to your environment:"
		elog " DBUS_SESSION_BUS_ADDRESS=\"launchd:env=DBUS_LAUNCHD_SESSION_BUS_SOCKET\""
	fi
}
