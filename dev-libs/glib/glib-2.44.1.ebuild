# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# Until bug #537330 glib is a reverse dependency of pkgconfig and, then
# adding new dependencies end up making stage3 to grow. Every addition needs
# then to be think very closely.

EAPI="5"
PYTHON_COMPAT=( python2_7 )
# Building with --disable-debug highly unrecommended.  It will build glib in
# an unusable form as it disables some commonly used API.  Please do not
# convert this to the use_enable form, as it results in a broken build.
GCONF_DEBUG="yes"
# Completely useless with or without USE static-libs, people need to use
# pkg-config
GNOME2_LA_PUNT="yes"

inherit autotools bash-completion-r1 gnome2 libtool eutils flag-o-matic	multilib \
	pax-utils python-r1 toolchain-funcs versionator virtualx linux-info multilib-minimal

DESCRIPTION="The GLib library of C routines"
HOMEPAGE="http://www.gtk.org/"
SRC_URI="${SRC_URI}
	http://pkgconfig.freedesktop.org/releases/pkg-config-0.28.tar.gz" # pkg.m4 for eautoreconf

LICENSE="LGPL-2+"
SLOT="2"
IUSE="dbus fam kernel_linux +mime selinux static-libs systemtap test utils xattr"
REQUIRED_USE="
	utils? ( ${PYTHON_REQUIRED_USE} )
	test? ( ${PYTHON_REQUIRED_USE} )
"

KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux"

RDEPEND="
	!<dev-util/gdbus-codegen-${PV}
	>=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]
	>=virtual/libffi-3.0.13-r1[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	|| (
		>=dev-libs/elfutils-0.142
		>=dev-libs/libelf-0.8.12
		>=sys-freebsd/freebsd-lib-9.2_rc1
		)
	selinux? ( >=sys-libs/libselinux-2.2.2-r5[${MULTILIB_USEDEP}] )
	xattr? ( >=sys-apps/attr-2.4.47-r1[${MULTILIB_USEDEP}] )
	fam? ( >=virtual/fam-0-r1[${MULTILIB_USEDEP}] )
	utils? (
		${PYTHON_DEPS}
		>=dev-util/gdbus-codegen-${PV}[${PYTHON_USEDEP}] )
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20130224-r9
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)
"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	>=dev-libs/libxslt-1.0
	>=sys-devel/gettext-0.11
	>=dev-util/gtk-doc-am-1.20
	systemtap? ( >=dev-util/systemtap-1.3 )
	test? (
		sys-devel/gdb
		${PYTHON_DEPS}
		>=dev-util/gdbus-codegen-${PV}[${PYTHON_USEDEP}]
		>=sys-apps/dbus-1.2.14 )
	!<dev-util/gtk-doc-1.15-r2
"
# gobject-introspection blocker to ensure people don't mix
# different g-i and glib major versions

PDEPEND="!<gnome-base/gvfs-1.6.4-r990
	dbus? ( gnome-base/dconf )
	mime? ( x11-misc/shared-mime-info )
"
# shared-mime-info needed for gio/xdgmime, bug #409481
# dconf is needed to be able to save settings, bug #498436
# Earlier versions of gvfs do not work with glib

pkg_setup() {
	if use kernel_linux ; then
		CONFIG_CHECK="~INOTIFY_USER"
		if use test; then
			CONFIG_CHECK="~IPV6"
			WARNING_IPV6="Your kernel needs IPV6 support for running some tests, skipping them."
			export IPV6_DISABLED="yes"
		fi
		linux-info_pkg_setup
	fi
}

src_prepare() {
	# Prevent build failure in stage3 where pkgconfig is not available, bug #481056
	mv -f "${WORKDIR}"/pkg-config-*/pkg.m4 "${S}"/m4macros/ || die

	if use test; then
		# Disable tests requiring dev-util/desktop-file-utils when not installed, bug #286629, upstream bug #629163
		if ! has_version dev-util/desktop-file-utils ; then
			ewarn "Some tests will be skipped due dev-util/desktop-file-utils not being present on your system,"
			ewarn "think on installing it to get these tests run."
			sed -i -e "/appinfo\/associations/d" gio/tests/appinfo.c || die
			sed -i -e "/desktop-app-info\/default/d" gio/tests/desktop-app-info.c || die
			sed -i -e "/desktop-app-info\/fallback/d" gio/tests/desktop-app-info.c || die
			sed -i -e "/desktop-app-info\/lastused/d" gio/tests/desktop-app-info.c || die
		fi

		# gdesktopappinfo requires existing terminal (gnome-terminal or any
		# other), falling back to xterm if one doesn't exist
		if ! has_version x11-terms/xterm && ! has_version x11-terms/gnome-terminal ; then
			ewarn "Some tests will be skipped due to missing terminal program"
			sed -i -e "/appinfo\/launch/d" gio/tests/appinfo.c || die
		fi

		# Disable tests requiring dbus-python and pygobject; bugs #349236, #377549, #384853
		if ! has_version dev-python/dbus-python || ! has_version 'dev-python/pygobject:3' ; then
			ewarn "Some tests will be skipped due to dev-python/dbus-python or dev-python/pygobject:3"
			ewarn "not being present on your system, think on installing them to get these tests run."
			sed -i -e "/connection\/filter/d" gio/tests/gdbus-connection.c || die
			sed -i -e "/connection\/large_message/d" gio/tests/gdbus-connection-slow.c || die
			sed -i -e "/gdbus\/proxy/d" gio/tests/gdbus-proxy.c || die
			sed -i -e "/gdbus\/proxy-well-known-name/d" gio/tests/gdbus-proxy-well-known-name.c || die
			sed -i -e "/gdbus\/introspection-parser/d" gio/tests/gdbus-introspection.c || die
			sed -i -e "/g_test_add_func/d" gio/tests/gdbus-threading.c || die
			sed -i -e "/gdbus\/method-calls-in-thread/d" gio/tests/gdbus-threading.c || die
			# needed to prevent gdbus-threading from asserting
			ln -sfn $(type -P true) gio/tests/gdbus-testserver.py
		fi

		# Some tests need ipv6, upstream bug #667468
		if [[ -n "${IPV6_DISABLED}" ]]; then
			sed -i -e "/gdbus\/peer-to-peer/d" gio/tests/gdbus-peer.c || die
			sed -i -e "/gdbus\/delayed-message-processing/d" gio/tests/gdbus-peer.c || die
			sed -i -e "/gdbus\/nonce-tcp/d" gio/tests/gdbus-peer.c || die
		fi

		# thread test fails, upstream bug #679306
		# FIXME: we need to check if it's still failing as upstream thinks something
		# is wrong in our setups
		#epatch "${FILESDIR}/${PN}-2.34.0-testsuite-skip-thread4.patch"

		# This test is prone to fail, bug #504024, upstream bug #723719
		sed -i -e '/gdbus-close-pending/d' gio/tests/Makefile.am || die
	else
		# Don't build tests, also prevents extra deps, bug #512022
		sed -i -e 's/ tests//' {.,gio,glib}/Makefile.am || die
	fi

	# gdbus-codegen is a separate package
	epatch "${FILESDIR}/${PN}-2.40.0-external-gdbus-codegen.patch"

	# leave python shebang alone
	sed -e '/${PYTHON}/d' \
		-i glib/Makefile.{am,in} || die

	# Gentoo handles completions in a different directory
	sed -i "s|^completiondir =.*|completiondir = $(get_bashcompdir)|" \
		gio/Makefile.am || die

	epatch_user

	# Also needed to prevent cross-compile failures, see bug #267603
	eautoreconf

	gnome2_src_prepare

	epunt_cxx
}

multilib_src_configure() {
	# Avoid circular depend with dev-util/pkgconfig and
	# native builds (cross-compiles won't need pkg-config
	# in the target ROOT to work here)
	if ! tc-is-cross-compiler && ! $(tc-getPKG_CONFIG) --version >& /dev/null; then
		if has_version sys-apps/dbus; then
			export DBUS1_CFLAGS="-I/usr/include/dbus-1.0 -I/usr/$(get_libdir)/dbus-1.0/include"
			export DBUS1_LIBS="-ldbus-1"
		fi
		export LIBFFI_CFLAGS="-I$(echo /usr/$(get_libdir)/libffi-*/include)"
		export LIBFFI_LIBS="-lffi"
	fi

	local myconf

	case "${CHOST}" in
		*-mingw*) myconf="${myconf} --with-threads=win32" ;;
		*)        myconf="${myconf} --with-threads=posix" ;;
	esac

	# Only used by the gresource bin
	multilib_is_native_abi || myconf="${myconf} --disable-libelf"

	# FIXME: Always use internal libpcre, bug #254659
	# (maybe consider going back to system lib
	ECONF_SOURCE="${S}" gnome2_src_configure ${myconf} \
		$(use_enable xattr) \
		$(use_enable fam) \
		$(use_enable selinux) \
		$(use_enable static-libs static) \
		$(use_enable systemtap dtrace) \
		$(use_enable systemtap systemtap) \
		--disable-compile-warnings \
		--enable-man \
		--with-pcre=internal \
		--with-xml-catalog="${EPREFIX}/etc/xml/catalog"

	if multilib_is_native_abi; then
		local d
		for d in glib gio gobject; do
			ln -s "${S}"/docs/reference/${d}/html docs/reference/${d}/html || die
		done
	fi
}

multilib_src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	export XDG_CONFIG_DIRS=/etc/xdg
	export XDG_DATA_DIRS=/usr/local/share:/usr/share
	export G_DBUS_COOKIE_SHA1_KEYRING_DIR="${T}/temp"
	unset GSETTINGS_BACKEND # bug 352451
	export LC_TIME=C # bug #411967
	python_export_best

	# Related test is a bit nitpicking
	mkdir "$G_DBUS_COOKIE_SHA1_KEYRING_DIR"
	chmod 0700 "$G_DBUS_COOKIE_SHA1_KEYRING_DIR"

	# Hardened: gdb needs this, bug #338891
	if host-is-pax ; then
		pax-mark -mr "${BUILD_DIR}"/tests/.libs/assert-msg-test \
			|| die "Hardened adjustment failed"
	fi

	# Need X for dbus-launch session X11 initialization
	Xemake check
}

multilib_src_install() {
	gnome2_src_install
}

multilib_src_install_all() {
	DOCS="AUTHORS ChangeLog* NEWS* README"
	einstalldocs

	if use utils ; then
		python_replicate_script "${ED}"/usr/bin/gtester-report
	else
		rm "${ED}usr/bin/gtester-report"
		rm "${ED}usr/share/man/man1/gtester-report.1"
	fi

	# Do not install charset.alias even if generated, leave it to libiconv
	rm -f "${ED}/usr/lib/charset.alias"

	# Don't install gdb python macros, bug 291328
	rm -rf "${ED}/usr/share/gdb/" "${ED}/usr/share/glib-2.0/gdb/"
}

pkg_postinst() {
	gnome2_pkg_postinst
	if has_version '<x11-libs/gtk+-3.0.12:3'; then
		# To have a clear upgrade path for gtk+-3.0.x users, have to resort to
		# a warning instead of a blocker
		ewarn
		ewarn "Using <gtk+-3.0.12:3 with ${P} results in frequent crashes."
		ewarn "You should upgrade to a newer version of gtk+:3 immediately."
	fi
}
