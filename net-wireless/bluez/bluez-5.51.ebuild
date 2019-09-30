# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit autotools python-single-r1 readme.gentoo-r1 systemd udev multilib-minimal

DESCRIPTION="Bluetooth Tools and System Daemons for Linux"
HOMEPAGE="http://www.bluez.org"
SRC_URI="https://www.kernel.org/pub/linux/bluetooth/${P}.tar.xz"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/3"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~x86"
IUSE="btpclient cups doc debug deprecated extra-tools experimental +mesh midi +obex +readline selinux systemd test test-programs +udev user-session"

# Since this release all remaining extra-tools need readline support, but this could
# change in the future, hence, this REQUIRED_USE constraint could be dropped
# again in the future.
REQUIRED_USE="
	extra-tools? ( deprecated readline )
	test? ( ${PYTHON_REQUIRED_USE} )
	test-programs? ( ${PYTHON_REQUIRED_USE} )
"

TEST_DEPS="${PYTHON_DEPS}
	>=dev-python/dbus-python-1[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
"
BDEPEND="
	virtual/pkgconfig
	test? ( ${TEST_DEPS} )
"
DEPEND="
	>=dev-libs/glib-2.28:2[${MULTILIB_USEDEP}]
	>=sys-apps/hwids-20121202.2
	btpclient? ( >=dev-libs/ell-0.14 )
	cups? ( net-print/cups:= )
	mesh? (
		>=dev-libs/ell-0.14
		dev-libs/json-c:=
		sys-libs/readline:0=
	)
	midi? ( media-libs/alsa-lib )
	obex? ( dev-libs/libical:= )
	readline? ( sys-libs/readline:0= )
	systemd? (
		>=sys-apps/dbus-1.6:=[user-session=]
		sys-apps/systemd
	)
	!systemd? ( >=sys-apps/dbus-1.6:= )
	udev? ( >=virtual/udev-172 )
"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-bluetooth )
	test-programs? ( ${TEST_DEPS} )
"

RESTRICT="!test? ( test )"

PATCHES=(
	# Try both udevadm paths to cover udev/systemd vs. eudev locations (#539844)
	# http://www.spinics.net/lists/linux-bluetooth/msg58739.html
	# https://bugs.gentoo.org/539844
	"${FILESDIR}"/${PN}-udevadm-path-r1.patch

	# build: Quote systemd variable names, bug #527432
	# http://article.gmane.org/gmane.linux.bluez.kernel/67230
	"${FILESDIR}"/${PN}-5.39-systemd-quote.patch

	# Fedora patches
	# http://www.spinics.net/lists/linux-bluetooth/msg40136.html
	"${FILESDIR}"/0001-obex-Use-GLib-helper-function-to-manipulate-paths.patch
)

pkg_setup() {
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
	if ! use user-session || ! use systemd; then
		eapply "${FILESDIR}"/0001-Allow-using-obexd-without-systemd-in-the-user-session-r1.patch
	fi

	if use cups; then
		sed -i \
			-e "s:cupsdir = \$(libdir)/cups:cupsdir = $(cups-config --serverbin):" \
			Makefile.{in,tools} || die
	fi

	# Broken test https://bugzilla.kernel.org/show_bug.cgi?id=196621
	# https://bugs.gentoo.org/618548
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

	econf \
		--localstatedir=/var \
		--disable-android \
		--enable-datafiles \
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
		$(multilib_native_use_enable btpclient) \
		$(multilib_native_use_enable btpclient external-ell) \
		$(multilib_native_use_enable cups) \
		$(multilib_native_use_enable deprecated) \
		$(multilib_native_use_enable experimental) \
		$(multilib_native_use_enable mesh) \
		$(multilib_native_use_enable mesh external-ell) \
		$(multilib_native_use_enable midi) \
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
			dobin tools/btmgmt
			# gatttool is only built with readline, bug #530776
			# https://bugzilla.redhat.com/show_bug.cgi?id=1141909
			# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=720486
			# https://bugs.archlinux.org/task/37686
			dobin attrib/gatttool
			# https://bugzilla.redhat.com/show_bug.cgi?id=1699680
			dobin tools/avinfo
		fi

		# Not installed by default after being built, bug #666756
		use btpclient && dobin tools/btpclient

		# Unittests are not that useful once installed, so make them optional
		if use test-programs; then
			# Few are needing python3, the others are python2 only. Remove
			# until we see how to pull in python2 and python3 for runtime
			rm "${ED}"/usr/$(get_libdir)/bluez/test/example-gatt-server || die
			rm "${ED}"/usr/$(get_libdir)/bluez/test/example-gatt-client || die
			rm "${ED}"/usr/$(get_libdir)/bluez/test/agent.py || die
			rm "${ED}"/usr/$(get_libdir)/bluez/test/test-mesh || die

			python_fix_shebang "${ED}"/usr/$(get_libdir)/bluez/test

			for i in $(find "${ED}"/usr/$(get_libdir)/bluez/test -maxdepth 1 -type f ! -name "*.*"); do
				dosym "${i}" /usr/bin/bluez-"${i##*/}"
			done
		fi
	else
		emake DESTDIR="${D}" \
			install-pkgincludeHEADERS \
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
	if use user-session && use systemd; then
		ln -s "${ED}"/usr/lib/systemd/user/obex.service "${ED}"/usr/lib/systemd/user/dbus-org.bluez.obex.service
	fi

	find "${D}" -name '*.la' -type f -delete || die

	keepdir /var/lib/bluetooth

	# Upstream don't want people to play with them
	# But we keep installing them due to 'historical' reasons
	insinto /etc/bluetooth
	local d
	for d in input network; do
		doins profiles/${d}/${d}.conf
	done
	# Setup auto enable as Fedora does for allowing to use
	# keyboards/mouse as soon as possible
	sed -i 's/#\[Policy\]$/\[Policy\]/; s/#AutoEnable=false/AutoEnable=true/' src/main.conf || die
	doins src/main.conf

	newinitd "${FILESDIR}"/bluetooth-init.d-r4 bluetooth

	einstalldocs
	use doc && dodoc doc/*.txt
	# Install .json files as examples to be used by meshctl
	if use mesh; then
		dodoc tools/mesh/*.json
		local DOC_CONTENTS="Some example .json files were installed into
		/usr/share/doc/${PF} to be used with meshctl. Feel free to
		uncompress and copy them to ~/.config/meshctl to use them."
		readme.gentoo_create_doc
	fi

	# From Fedora:
	# Scripts for automatically btattach-ing serial ports connected to Broadcom HCIs
	# as found on some Atom based x86 hardware
	udev_dorules "${FILESDIR}/69-btattach-bcm.rules"
	systemd_newunit "${FILESDIR}/btattach-bcm_at.service" "btattach-bcm@.service"
	exeinto /usr/libexec/bluetooth
	doexe "${FILESDIR}/btattach-bcm-service.sh"
}

pkg_postinst() {
	use udev && udev_reload
	systemd_reenable bluetooth.service

	has_version net-dialup/ppp || elog "To use dial up networking you must install net-dialup/ppp"
	use mesh && readme.gentoo_print_elog
}
