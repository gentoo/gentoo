# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="gdbm"

WANT_AUTOMAKE=1.11

inherit autotools eutils flag-o-matic multilib multilib-minimal mono-env python-r1 systemd user

DESCRIPTION="System which facilitates service discovery on a local network"
HOMEPAGE="http://avahi.org/"
SRC_URI="https://github.com/lathiat/avahi/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${P}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~mips ppc ppc64 sparc x86"
IUSE="autoipd bookmarks dbus doc gdbm gtk gtk3 howl-compat +introspection ipv6 kernel_linux mdnsresponder-compat mono nls python qt4 selinux test utils"

REQUIRED_USE="
	utils? ( || ( gtk gtk3 ) )
	python? ( dbus gdbm ${PYTHON_REQUIRED_USE} )
	mono? ( dbus )
	howl-compat? ( dbus )
	mdnsresponder-compat? ( dbus )
"

COMMON_DEPEND="
	dev-libs/libdaemon
	dev-libs/expat
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	gdbm? ( sys-libs/gdbm[${MULTILIB_USEDEP}] )
	qt4? ( dev-qt/qtcore:4[${MULTILIB_USEDEP}] )
	gtk? ( x11-libs/gtk+:2[${MULTILIB_USEDEP}] )
	gtk3? ( x11-libs/gtk+:3[${MULTILIB_USEDEP}] )
	dbus? ( sys-apps/dbus[${MULTILIB_USEDEP}] )
	kernel_linux? ( sys-libs/libcap )
	introspection? ( dev-libs/gobject-introspection:= )
	mono? (
		dev-lang/mono
		gtk? ( dev-dotnet/gtk-sharp )
	)
	python? (
		${PYTHON_DEPS}
		gtk? ( dev-python/pygtk )
		dbus? ( dev-python/dbus-python )
	)
	bookmarks? (
		dev-python/twisted-core
		dev-python/twisted-web
	)
"

DEPEND="
	${COMMON_DEPEND}
	doc? ( app-doc/doxygen )
	app-doc/xmltoman
	dev-util/intltool
	virtual/pkgconfig[${MULTILIB_USEDEP}]
"

RDEPEND="
	${COMMON_DEPEND}
	howl-compat? ( !net-misc/howl )
	mdnsresponder-compat? ( !net-misc/mDNSResponder )
	selinux? ( sec-policy/selinux-avahi )
"

pkg_preinst() {
	enewgroup netdev
	enewgroup avahi
	enewuser avahi -1 -1 -1 avahi

	if use autoipd; then
		enewgroup avahi-autoipd
		enewuser avahi-autoipd -1 -1 -1 avahi-autoipd
	fi
}

pkg_setup() {
	use mono && mono-env_pkg_setup
}

src_prepare() {
	if ! use ipv6; then
		sed -i \
			-e s/use-ipv6=yes/use-ipv6=no/ \
			avahi-daemon/avahi-daemon.conf || die
	fi

	sed -i\
		-e "s:\\.\\./\\.\\./\\.\\./doc/avahi-docs/html/:../../../doc/${PF}/html/:" \
		doxygen_to_devhelp.xsl || die

	# Make gtk utils optional
	# https://github.com/lathiat/avahi/issues/24
	epatch "${FILESDIR}"/${PN}-0.6.30-optional-gtk-utils.patch

	# Don't install avahi-discover unless ENABLE_GTK_UTILS, bug #359575
	# https://github.com/lathiat/avahi/issues/24
	epatch "${FILESDIR}"/${PN}-0.6.31-fix-install-avahi-discover.patch

	# Fix build under various locales, bug #501664
	# https://github.com/lathiat/avahi/issues/27
	epatch "${FILESDIR}"/${PN}-0.6.31-fix-locale-build.patch

	# Bug #525832
	epatch_user

	# Prevent .pyc files in DESTDIR
	>py-compile

	eautoreconf

	# bundled manpages
	multilib_copy_sources
}

src_configure() {
	# those steps should be done once-per-ebuild rather than per-ABI
	use sh && replace-flags -O? -O0
	use python && python_export_best

	# We need to unset DISPLAY, else the configure script might have problems detecting the pygtk module
	unset DISPLAY

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local myconf=( --disable-static )

	if use python; then
		myconf+=(
			$(multilib_native_use_enable dbus python-dbus)
			$(multilib_native_use_enable gtk pygtk)
		)
	fi

	if use mono; then
		myconf+=( $(multilib_native_use_enable doc monodoc) )
	fi

	if ! multilib_is_native_abi; then
		myconf+=(
			# used by daemons only
			--disable-libdaemon
			--with-xml=none
		)
	fi

	econf \
		--localstatedir="${EPREFIX}/var" \
		--with-distro=gentoo \
		--disable-python-dbus \
		--disable-pygtk \
		--enable-manpages \
		--enable-xmltoman \
		--disable-monodoc \
		--enable-glib \
		--enable-gobject \
		$(multilib_native_use_enable test tests) \
		$(multilib_native_use_enable autoipd) \
		$(use_enable mdnsresponder-compat compat-libdns_sd) \
		$(use_enable howl-compat compat-howl) \
		$(multilib_native_use_enable doc doxygen-doc) \
		$(multilib_native_use_enable mono) \
		$(use_enable dbus) \
		$(multilib_native_use_enable python) \
		$(use_enable gtk) \
		$(use_enable gtk3) \
		$(use_enable nls) \
		$(multilib_native_use_enable introspection) \
		$(multilib_native_use_enable utils gtk-utils) \
		--disable-qt3 \
		$(use_enable qt4) \
		$(use_enable gdbm) \
		$(systemd_with_unitdir) \
		"${myconf[@]}"
}

multilib_src_compile() {
	emake

	multilib_is_native_abi && use doc && emake avahi.devhelp
}

multilib_src_install() {
	emake install DESTDIR="${D}"
	use bookmarks && use python && use dbus && use gtk || \
		rm -f "${ED}"/usr/bin/avahi-bookmarks

	# https://github.com/lathiat/avahi/issues/28
	use howl-compat && dosym avahi-compat-howl.pc /usr/$(get_libdir)/pkgconfig/howl.pc
	use mdnsresponder-compat && dosym avahi-compat-libdns_sd/dns_sd.h /usr/include/dns_sd.h

	if multilib_is_native_abi && use doc; then
		dohtml -r doxygen/html/. || die
		insinto /usr/share/devhelp/books/avahi
		doins avahi.devhelp || die
	fi
}

multilib_src_install_all() {
	if use autoipd; then
		insinto /$(get_libdir)/rcscripts/net
		doins "${FILESDIR}"/autoipd.sh

		insinto /$(get_libdir)/netifrc/net
		newins "${FILESDIR}"/autoipd-openrc.sh autoipd.sh
	fi

	dodoc docs/{AUTHORS,NEWS,README,TODO}

	prune_libtool_files --all
}

pkg_postinst() {
	if use autoipd; then
		elog
		elog "To use avahi-autoipd to configure your interfaces with IPv4LL (RFC3927)"
		elog "addresses, just set config_<interface>=( autoipd ) in /etc/conf.d/net!"
		elog
	fi
}
