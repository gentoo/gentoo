# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python3_{4,5} )

inherit autotools eutils multilib python-single-r1 readme.gentoo-r1 systemd udev user multilib-minimal

DESCRIPTION="Bluetooth Tools and System Daemons for Linux"
HOMEPAGE="http://www.bluez.org"
SRC_URI="mirror://kernel/linux/bluetooth/${P}.tar.xz"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/3"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~x86"

IUSE="cups doc debug extra-tools experimental +obex +readline selinux systemd test test-programs +udev"
REQUIRED_USE="
	test? ( ${PYTHON_REQUIRED_USE} )
	test-programs? ( ${PYTHON_REQUIRED_USE} )
"

CDEPEND="
	>=dev-libs/glib-2.28:2
	>=sys-apps/dbus-1.6:=
	>=sys-apps/hwids-20121202.2
	cups? ( net-print/cups:= )
	obex? ( dev-libs/libical:= )
	readline? ( sys-libs/readline:= )
	systemd? ( sys-apps/systemd )
	udev? ( >=virtual/udev-172 )
"
TEST_DEPS="${PYTHON_DEPS}
		>=dev-python/dbus-python-1[${PYTHON_USEDEP}]
		|| (
			dev-python/pygobject:3[${PYTHON_USEDEP}]
			dev-python/pygobject:2[${PYTHON_USEDEP}]
		)
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
	If you want to use rfcomm as a normal user, you need to add the user
	to the uucp group.
"

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

	# Use static group "plugdev" if there is no ConsoleKit (or systemd logind)
	epatch "${FILESDIR}"/bluez-plugdev.patch

	# Try both udevadm paths to cover udev/systemd vs. eudev locations (#539844)
	# http://www.spinics.net/lists/linux-bluetooth/msg58739.html
	epatch "${FILESDIR}"/bluez-udevadm-path.patch

	# Fedora patches
	# http://www.spinics.net/lists/linux-bluetooth/msg38490.html
	epatch "${FILESDIR}"/0001-Allow-using-obexd-without-systemd-in-the-user-sessio.patch

	# http://www.spinics.net/lists/linux-bluetooth/msg40136.html
	epatch "${FILESDIR}"/0001-obex-Use-GLib-helper-function-to-manipulate-paths.patch

	# http://www.spinics.net/lists/linux-bluetooth/msg41264.html
	epatch "${FILESDIR}"/0002-autopair-Don-t-handle-the-iCade.patch

	# ???
	epatch "${FILESDIR}"/0004-agent-Assert-possible-infinite-loop.patch

	if use cups; then
		sed -i \
			-e "s:cupsdir = \$(libdir)/cups:cupsdir = $(cups-config --serverbin):" \
			Makefile.{in,tools} || die
	fi

	eautoreconf

	multilib_copy_sources
}

multilib_src_configure() {
	local myconf=(
		# readline is automagic when client is enabled
		# --enable-client always needs readline, bug #504038
		ac_cv_header_readline_readline_h=$(multilib_native_usex readline)
	)

	if ! multilib_is_native_abi; then
		myconf+=(
			# deps not used for the library
			{DBUS,GLIB}_{CFLAGS,LIBS}=' '
		)
	fi

	econf \
		--localstatedir=/var \
		--disable-android \
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
		$(multilib_native_use_enable cups) \
		$(multilib_native_use_enable experimental) \
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
			if use readline; then
				dobin attrib/gatttool
				dobin tools/btmgmt
			fi
			dobin tools/hex2hcd
		fi

		# Unittests are not that useful once installed, so make them optional
		if use test-programs; then
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
	prune_libtool_files --modules

	keepdir /var/lib/bluetooth

	# Upstream don't want people to play with them
	# But we keep installing them due to 'historical' reasons
	insinto /etc/bluetooth
	local d
	for d in input network proximity; do
		doins profiles/${d}/${d}.conf
	done
	doins src/main.conf

	newinitd "${FILESDIR}"/bluetooth-init.d-r3 bluetooth
	newinitd "${FILESDIR}"/rfcomm-init.d-r2 rfcomm

	einstalldocs
	use doc && dodoc doc/*.txt
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog

	use udev && udev_reload

	has_version net-dialup/ppp || elog "To use dial up networking you must install net-dialup/ppp."

	if ! has_version sys-auth/consolekit && ! has_version sys-apps/systemd; then
		elog "Since you don't have sys-auth/consolekit neither sys-apps/systemd, you will"
		elog "need to add the user to the plugdev group."
	fi
}
