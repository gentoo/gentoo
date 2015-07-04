# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/dbus/dbus-1.8.18.ebuild,v 1.1 2015/07/04 16:20:14 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils linux-info flag-o-matic python-any-r1 readme.gentoo systemd virtualx user multilib-minimal

DESCRIPTION="A message bus system, a simple way for applications to talk to each other"
HOMEPAGE="http://dbus.freedesktop.org/"
SRC_URI="http://dbus.freedesktop.org/releases/dbus/${P}.tar.gz"

LICENSE="|| ( AFL-2.1 GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="debug doc selinux static-libs systemd test X"

CDEPEND="
	>=dev-libs/expat-2
	selinux? (
		sys-libs/libselinux
		)
	systemd? ( sys-apps/systemd:0= )
	X? (
		x11-libs/libX11
		x11-libs/libXt
		)
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20131008-r4
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)
"
DEPEND="${CDEPEND}
	app-text/xmlto
	app-text/docbook-xml-dtd:4.4
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? (
		>=dev-libs/glib-2.24:2
		${PYTHON_DEPS}
		)
"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-dbus )
"

DOC_CONTENTS="
	Some applications require a session bus in addition to the system
	bus. Please see \`man dbus-launch\` for more information.
"

# out of sources build dir for make check
TBD=${WORKDIR}/${P}-tests-build

pkg_setup() {
	enewgroup messagebus
	enewuser messagebus -1 -1 -1 messagebus

	use test && python-any-r1_pkg_setup

	if use kernel_linux; then
		CONFIG_CHECK="~EPOLL"
		linux-info_pkg_setup
	fi
}

src_prepare() {
	# Tests were restricted because of this
	sed -i \
		-e 's/.*bus_dispatch_test.*/printf ("Disabled due to excess noise\\n");/' \
		-e '/"dispatch"/d' \
		bus/test-main.c || die

	epatch_user

	# required for asneeded patch but also for bug 263909, cross-compile so
	# don't remove eautoreconf
	eautoreconf
}

multilib_src_configure() {
	local docconf myconf

	# so we can get backtraces from apps
	case ${CHOST} in
		*-mingw*)
			# error: unrecognized command line option '-rdynamic' wrt #488036
			;;
		*)
			append-flags -rdynamic
			;;
	esac

	# libaudit is *only* used in DBus wrt SELinux support, so disable it, if
	# not on an SELinux profile.
	myconf=(
		--localstatedir="${EPREFIX}/var"
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
		--htmldir="${EPREFIX}/usr/share/doc/${PF}/html"
		$(use_enable static-libs static)
		$(use_enable debug verbose-mode)
		--disable-asserts
		--disable-checks
		$(use_enable selinux)
		$(use_enable selinux libaudit)
		$(use_enable kernel_linux inotify)
		$(use_enable kernel_FreeBSD kqueue)
		$(use_enable systemd)
		--disable-embedded-tests
		--disable-modular-tests
		$(use_enable debug stats)
		--with-session-socket-dir="${EPREFIX}"/tmp
		--with-system-pid-file="${EPREFIX}"/var/run/dbus.pid
		--with-system-socket="${EPREFIX}"/var/run/dbus/system_bus_socket
		--with-dbus-user=messagebus
		$(use_with X x)
		"$(systemd_with_unitdir)"
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
			--disable-selinux
			--disable-libaudit
			--disable-systemd
			--without-x

			# expat is used for the daemon only
			# fake the check for multilib library build
			ac_cv_lib_expat_XML_ParserCreate_MM=yes
		)
	fi

	einfo "Running configure in ${BUILD_DIR}"
	ECONF_SOURCE="${S}" econf "${myconf[@]}" "${docconf[@]}"

	if multilib_is_native_abi && use test; then
		mkdir "${TBD}" || die
		cd "${TBD}" || die
		einfo "Running configure in ${TBD}"
		ECONF_SOURCE="${S}" econf "${myconf[@]}" \
			$(use_enable test asserts) \
			$(use_enable test checks) \
			$(use_enable test embedded-tests) \
			$(has_version dev-libs/dbus-glib && echo --enable-modular-tests)
	fi
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		# after the compile, it uses a selinuxfs interface to
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
	DBUS_VERBOSE=1 Xemake -j1 -C "${TBD}" check
}

multilib_src_install() {
	if multilib_is_native_abi; then
		emake DESTDIR="${D}" install
	else
		emake DESTDIR="${D}" install-pkgconfigDATA
		emake DESTDIR="${D}" -C dbus \
			install-libLTLIBRARIES install-dbusincludeHEADERS \
			install-nodist_dbusarchincludeHEADERS
	fi
}

multilib_src_install_all() {
	newinitd "${FILESDIR}"/dbus.initd dbus

	if use X; then
		# dbus X session script (#77504)
		# turns out to only work for GDM (and startx). has been merged into
		# other desktop (kdm and such scripts)
		exeinto /etc/X11/xinit/xinitrc.d
		doexe "${FILESDIR}"/80-dbus
	fi

	# needs to exist for dbus sessions to launch
	keepdir /usr/share/dbus-1/services
	keepdir /etc/dbus-1/{session,system}.d
	# machine-id symlink from pkg_postinst()
	keepdir /var/lib/dbus
	# let the init script create the /var/run/dbus directory
	rm -rf "${ED}"/var/run

	dodoc AUTHORS ChangeLog HACKING NEWS README doc/TODO
	readme.gentoo_create_doc

	prune_libtool_files --all
}

pkg_postinst() {
	readme.gentoo_print_elog

	# Ensure unique id is generated and put it in /etc wrt #370451 but symlink
	# for DBUS_MACHINE_UUID_FILE (see tools/dbus-launch.c) and reverse
	# dependencies with hardcoded paths (although the known ones got fixed already)
	dbus-uuidgen --ensure="${EROOT%/}"/etc/machine-id
	ln -sf "${EROOT%/}"/etc/machine-id "${EROOT%/}"/var/lib/dbus/machine-id

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
