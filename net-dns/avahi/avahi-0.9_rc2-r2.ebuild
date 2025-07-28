# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
PYTHON_REQ_USE="gdbm"
inherit autotools multilib-minimal python-single-r1 systemd

DESCRIPTION="System which facilitates service discovery on a local network"
HOMEPAGE="https://avahi.org/"
SRC_URI="https://github.com/lathiat/avahi/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${PV/_/-}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="autoipd bookmarks +dbus doc gdbm gtk howl-compat +introspection ipv6 mdnsresponder-compat nls python qt5 selinux systemd test"

REQUIRED_USE="
	python? ( dbus gdbm ${PYTHON_REQUIRED_USE} )
	bookmarks? ( python )
	howl-compat? ( dbus )
	mdnsresponder-compat? ( dbus )
	systemd? ( dbus )
"

RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/libdaemon
	dev-libs/libevent:=[${MULTILIB_USEDEP}]
	dev-libs/expat
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	gdbm? ( sys-libs/gdbm:=[${MULTILIB_USEDEP}] )
	qt5? ( dev-qt/qtcore:5 )
	gtk?  ( x11-libs/gtk+:3[${MULTILIB_USEDEP}] )
	dbus? ( sys-apps/dbus[${MULTILIB_USEDEP}] )
	kernel_linux? ( sys-libs/libcap )
	introspection? ( dev-libs/gobject-introspection:= )
	systemd? ( sys-apps/systemd:=[${MULTILIB_USEDEP}] )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			bookmarks? ( >=dev-python/twisted-16.0.0[${PYTHON_USEDEP}] )
			dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
			introspection? ( dev-python/pygobject:3[${PYTHON_USEDEP}] )
		')
	)
"
RDEPEND="
	acct-user/avahi
	acct-group/avahi
	acct-group/netdev
	autoipd? (
		acct-user/avahi-autoipd
		acct-group/avahi-autoipd
	)
	${DEPEND}
	selinux? ( sec-policy/selinux-avahi )
"
BDEPEND="
	dev-util/glib-utils
	doc? ( app-text/doxygen )
	app-text/xmltoman
	sys-devel/gettext
	virtual/pkgconfig
"

MULTILIB_WRAPPED_HEADERS=( /usr/include/avahi-qt5/qt-watch.h )

PATCHES=(
	"${FILESDIR}/avahi-0.9_rc1-disable-avahi-ui-sharp.patch" # bug 769062
	"${FILESDIR}/avahi-0.9_rc2-CVE-2024-52615.patch"
	"${FILESDIR}/avahi-0.9_rc2-glibc-2.42.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	if ! use ipv6; then
		sed -i \
			-e "s/use-ipv6=yes/use-ipv6=no/" \
			avahi-daemon/avahi-daemon.conf || die
	fi

	sed -i \
		-e "s:\\.\\./\\.\\./\\.\\./doc/avahi-docs/html/:../../../doc/${PF}/html/:" \
		doxygen_to_devhelp.xsl || die

	eautoreconf

	# bundled manpages
	multilib_copy_sources
}

multilib_src_configure() {
	local myconf=(
		--disable-gtk
		--disable-mono
		--disable-monodoc
		--disable-python-dbus
		--disable-qt3
		--disable-qt4
		--disable-static
		--enable-manpages
		--enable-glib
		--enable-gobject
		--enable-xmltoman
		--localstatedir="${EPREFIX}/var"
		--runstatedir="${EPREFIX}/run"
		--with-distro=gentoo
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		$(use_enable dbus)
		$(use_enable gdbm)
		$(use_enable gtk gtk3)
		$(use_enable howl-compat compat-howl)
		$(use_enable mdnsresponder-compat compat-libdns_sd)
		$(use_enable nls)
		$(use_enable systemd libsystemd)
		$(multilib_native_use_enable autoipd)
		$(multilib_native_use_enable doc doxygen-doc)
		$(multilib_native_use_enable introspection)
		$(multilib_native_use_enable python)
		$(multilib_native_use_enable test tests)
	)

	if use python; then
		myconf+=(
			$(multilib_native_use_enable dbus python-dbus)
			$(multilib_native_use_enable introspection pygobject)
		)
	fi

	if ! multilib_is_native_abi; then
		myconf+=(
			# used by daemons only
			--disable-libdaemon
			--with-xml=none
		)
	fi

	myconf+=( $(multilib_native_use_enable qt5) )

	econf "${myconf[@]}"
}

multilib_src_compile() {
	emake

	multilib_is_native_abi && use doc && emake avahi.devhelp
}

multilib_src_install() {
	emake install DESTDIR="${D}"

	if ! use bookmarks || ! use python || ! use dbus; then
		rm -f "${ED}"/usr/bin/avahi-bookmarks || die
	fi

	# https://github.com/lathiat/avahi/issues/28
	use howl-compat && dosym avahi-compat-howl.pc /usr/$(get_libdir)/pkgconfig/howl.pc
	use mdnsresponder-compat && dosym avahi-compat-libdns_sd/dns_sd.h /usr/include/dns_sd.h

	if multilib_is_native_abi && use doc; then
		docinto html
		dodoc -r doxygen/html/.
		insinto /usr/share/devhelp/books/avahi
		doins avahi.devhelp
	fi

	# The build system creates an empty "/run" directory, so we clean it up here
	rmdir "${ED}"/run || die
}

multilib_src_install_all() {
	use python && python_optimize

	if use autoipd; then
		insinto /lib/rcscripts/net
		doins "${FILESDIR}"/autoipd.sh

		insinto /lib/netifrc/net
		newins "${FILESDIR}"/autoipd-openrc.sh autoipd.sh
	fi

	dodoc docs/{AUTHORS,NEWS,README,TODO}

	find "${ED}" -name '*.la' -type f -delete || die
}

pkg_postinst() {
	if use autoipd; then
		elog
		elog "To use avahi-autoipd to configure your interfaces with IPv4LL (RFC3927)"
		elog "addresses, just set config_<interface>=( autoipd ) in /etc/conf.d/net!"
		elog
	fi

	systemd_reenable avahi-daemon.service
}
