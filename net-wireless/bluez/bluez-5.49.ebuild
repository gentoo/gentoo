# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit autotools multilib python-single-r1 readme.gentoo-r1 systemd udev user multilib-minimal

DESCRIPTION="Bluetooth Tools and System Daemons for Linux"
HOMEPAGE="http://www.bluez.org"
SRC_URI="mirror://kernel/linux/bluetooth/${P}.tar.xz"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/3"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~mips ~ppc ppc64 x86"
IUSE="alsa cups doc debug deprecated extra-tools experimental +mesh +obex +readline selinux systemd test test-programs +udev user-session"

# Since this release all remaining extra-tools need readline support, but this could
# change in the future, hence, this REQUIRED_USE constraint could be dropped
# again in the future.
REQUIRED_USE="
	extra-tools? ( deprecated readline )
	test? ( ${PYTHON_REQUIRED_USE} )
	test-programs? ( ${PYTHON_REQUIRED_USE} )
	user-session? ( systemd )
"

CDEPEND="
	>=dev-libs/glib-2.28:2[${MULTILIB_USEDEP}]
	>=sys-apps/dbus-1.6:=[user-session=]
	>=sys-apps/hwids-20121202.2
	alsa? ( media-libs/alsa-lib )
	cups? ( net-print/cups:= )
	mesh? (
		dev-libs/json-c:=
		sys-libs/readline:0= )
	obex? ( dev-libs/libical:= )
	readline? ( sys-libs/readline:0= )
	systemd? ( sys-apps/systemd )
	udev? ( >=virtual/udev-172 )
"
TEST_DEPS="${PYTHON_DEPS}
	>=dev-python/dbus-python-1[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
"

DEPEND="${CDEPEND}
	virtual/pkgconfig
	test? (	${TEST_DEPS} )
"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-bluetooth )
	test-programs? ( ${TEST_DEPS} )
"
DOC_CONTENTS="
	If you want to control your bluetooth devices as a non-root user,
	please remember to add you to plugdev group.
"

PATCHES=(
	# Use static group "plugdev" to not force people to become root for
	# controlling the devices.
	"${FILESDIR}"/bluez-plugdev.patch

	# Try both udevadm paths to cover udev/systemd vs. eudev locations (#539844)
	# http://www.spinics.net/lists/linux-bluetooth/msg58739.html
	"${FILESDIR}"/bluez-udevadm-path.patch

	# build: Quote systemd variable names, bug #527432
	# http://article.gmane.org/gmane.linux.bluez.kernel/67230
	"${FILESDIR}"/bluez-5.39-systemd-quote.patch

	# Fedora patches
	# http://www.spinics.net/lists/linux-bluetooth/msg40136.html
	"${FILESDIR}"/0001-obex-Use-GLib-helper-function-to-manipulate-paths.patch

	# ???
	"${FILESDIR}"/0004-agent-Assert-possible-infinite-loop.patch
)

pkg_setup() {
	enewgroup plugdev

	if use test || use test-programs; then
		python-single-r1_pkg_setup
	fi

	if ! use udev; then
		ewarn
		ewarn "You are installing ${PN} with USE=-udev. This means various bluetooth"
		ewarn "devices and adapters from Apple, Dell, Logitech etc. will not work,"
		ewarn "and hid2hci will not be available."
		ewarn
	fi
}

src_prepare() {
	default

	# http://www.spinics.net/lists/linux-bluetooth/msg38490.html
	! use user-session && eapply "${FILESDIR}"/0001-Allow-using-obexd-without-systemd-in-the-user-sessio.patch

	if use cups; then
		sed -i \
			-e "s:cupsdir = \$(libdir)/cups:cupsdir = $(cups-config --serverbin):" \
			Makefile.{in,tools} || die
	fi

	# Broken test https://bugzilla.kernel.org/show_bug.cgi?id=196621
	sed -i -e '/unit_tests += unit\/test-gatt\b/d' Makefile.am || die

	eautoreconf

	multilib_copy_sources
}

multilib_src_configure() {
	local myconf=(
		# readline is automagic when client is enabled
		# --enable-client always needs readline, bug #504038
		# --enable-mesh is handled in the same way
		ac_cv_header_readline_readline_h=$(multilib_native_usex readline)
		ac_cv_header_readline_readline_h=$(multilib_native_usex mesh)
	)

	if ! multilib_is_native_abi; then
		myconf+=(
			# deps not used for the library
			{DBUS,GLIB}_{CFLAGS,LIBS}=' '
		)
	fi

	# btpclient disabled because we don't have ell library in the tree
	econf \
		--localstatedir=/var \
		--disable-android \
		--disable-btpclient \
		--enable-datafiles \
		--enable-experimental \
		--enable-optimization \
		$(use_enable debug) \
		--enable-pie \
		--enable-threads \
		--enable-library \
		--enable-tools \
		--enable-manpages \
		--enable-monitor \
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)" \
		--with-systemduserunitdir="$(systemd_get_userunitdir)" \
		$(multilib_native_use_enable alsa midi) \
		$(multilib_native_use_enable cups) \
		$(multilib_native_use_enable deprecated) \
		$(multilib_native_use_enable experimental) \
		$(multilib_native_use_enable mesh) \
		$(multilib_native_use_enable obex) \
		$(multilib_native_use_enable readline client) \
		$(multilib_native_use_enable systemd) \
		$(multilib_native_use_enable test-programs test) \
		$(multilib_native_use_enable udev) \
		$(multilib_native_use_enable udev sixaxis)
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		default
	else
		emake -f Makefile -f - libs \
			<<<'libs: $(lib_LTLIBRARIES)'
	fi
}

multilib_src_test() {
	multilib_is_native_abi && default
}

multilib_src_install() {
	if multilib_is_native_abi; then
		emake DESTDIR="${D}" install

		# Only install extra-tools when relevant USE flag is enabled
		if use extra-tools; then
			ewarn "Upstream doesn't support using this tools and their bugs are"
			ewarn "likely to be ignored forever, also that tools can break"
			ewarn "without previous announcement."
			ewarn "Upstream also states all this tools are not really needed,"
			ewarn "then, if you still need to rely on them, you must ask them"
			ewarn "to either install that tool by default or add the needed"
			ewarn "functionality to the existing 'official' tools."
			ewarn "Please report this issues to:"
			ewarn "http://www.bluez.org/development/lists/"

			# Upstream doesn't install this, bug #524640
			# http://permalink.gmane.org/gmane.linux.bluez.kernel/53115
			# http://comments.gmane.org/gmane.linux.bluez.kernel/54564
			# gatttool is only built with readline, bug #530776
			dobin attrib/gatttool
			dobin tools/btmgmt
		fi

		# Unittests are not that useful once installed, so make them optional
		if use test-programs; then
			# example-gatt-client is the only one needing
			# python3, the others are python2 only. Remove
			# until we see how to pull in python2 and python3
			# for runtime
			rm "${ED}"/usr/$(get_libdir)/bluez/test/example-gatt-server || die
			rm "${ED}"/usr/$(get_libdir)/bluez/test/example-gatt-client || die
			python_fix_shebang "${ED}"/usr/$(get_libdir)/bluez/test
			for i in $(find "${ED}"/usr/$(get_libdir)/bluez/test -maxdepth 1 -type f ! -name "*.*"); do
				dosym "${i}" /usr/bin/bluez-"${i##*/}"
			done
		fi
	else
		emake DESTDIR="${D}" \
			install-includeHEADERS \
			install-libLTLIBRARIES \
			install-pkgconfigDATA
	fi
}

multilib_src_install_all() {
	# We need to ensure obexd can be spawned automatically by systemd
	# when user-session is enabled:
	# http://marc.info/?l=linux-bluetooth&m=148096094716386&w=2
	# https://bugs.gentoo.org/show_bug.cgi?id=577842
	# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=804908
	# https://bugs.archlinux.org/task/45816
	# https://bugzilla.redhat.com/show_bug.cgi?id=1318441
	# https://bugzilla.redhat.com/show_bug.cgi?id=1389347
	use user-session && ln -s "${ED}"/usr/lib/systemd/user/obex.service "${ED}"/usr/lib/systemd/user/dbus-org.bluez.obex.service

	find "${D}" -name '*.la' -delete || die

	keepdir /var/lib/bluetooth

	# Upstream don't want people to play with them
	# But we keep installing them due to 'historical' reasons
	insinto /etc/bluetooth
	local d
	for d in input network; do
		doins profiles/${d}/${d}.conf
	done
	doins src/main.conf

	newinitd "${FILESDIR}"/bluetooth-init.d-r4 bluetooth

	einstalldocs
	use doc && dodoc doc/*.txt
	! use systemd && readme.gentoo_create_doc
}

pkg_postinst() {
	! use systemd && readme.gentoo_print_elog

	use udev && udev_reload
	systemd_reenable bluetooth.service

	has_version net-dialup/ppp || elog "To use dial up networking you must install net-dialup/ppp."
}
