# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit autotools eutils multilib python-single-r1 readme.gentoo \
	systemd user multilib-minimal

DESCRIPTION="Bluetooth Tools and System Daemons for Linux"
HOMEPAGE="http://www.bluez.org/"
SRC_URI="mirror://kernel/linux/bluetooth/${P}.tar.xz
	http://dev.gentoo.org/~pacho/bluez/${P}-patches.tar.xz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm hppa ppc ppc64 x86"
IUSE="alsa cups debug gstreamer hid2hci pcmcia readline selinux test-programs usb"

REQUIRED_USE="test-programs? ( ${PYTHON_REQUIRED_USE} )"

# TODO: revisit USE=gstreamer once gstreamer is ported to multilib

CDEPEND="
	>=dev-libs/glib-2.28:2
	>=sys-apps/dbus-1.6:=
	>=sys-apps/hwids-20121202.2
	>=virtual/udev-171
	alsa? (
		>=media-libs/alsa-lib-1.0.27.2:=[${MULTILIB_USEDEP},alsa_pcm_plugins_extplug(+),alsa_pcm_plugins_ioplug(+)]
		media-libs/libsndfile:=
	)
	cups? ( net-print/cups:= )
	gstreamer? (
		>=media-libs/gstreamer-0.10:0.10
		>=media-libs/gst-plugins-base-0.10:0.10
	)
	readline? ( sys-libs/readline:= )
	selinux? ( sec-policy/selinux-bluetooth )
	usb? ( virtual/libusb:0 )
"
DEPEND="${CDEPEND}
	sys-devel/flex
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	test-programs? ( >=dev-libs/check-0.9.6 )
"
RDEPEND="${CDEPEND}
	test-programs? (
		>=dev-python/dbus-python-1
		dev-python/pygobject:2
		dev-python/pygobject:3
		${PYTHON_DEPS}
	)
	abi_x86_32? (
		!<app-emulation/emul-linux-x86-soundlibs-20140406-r1
		!app-emulation/emul-linux-x86-soundlibs[-abi_x86_32]
	)
"

DOCS=( AUTHORS ChangeLog README )

DOC_CONTENTS="
	If you want to use rfcomm as a normal user, you need to add the user
	to the uucp group.
"

pkg_setup() {
	enewgroup plugdev
	use test-programs && python-single-r1_pkg_setup
}

src_prepare() {
	# Fedora patches
	epatch "${WORKDIR}/${P}-patches"/*.patch

	# Use static group "plugdev" if there is no ConsoleKit (or systemd logind)
	epatch "${FILESDIR}"/bluez-plugdev.patch

	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.ac || die

	eautoreconf

	if use cups; then
		sed -i \
			-e "s:cupsdir = \$(libdir)/cups:cupsdir = `cups-config --serverbin`:" \
			Makefile.{in,tools} || die
	fi

	multilib_copy_sources
}

multilib_src_configure() {
	local myconf=(
		ac_cv_header_readline_readline_h=$(multilib_native_usex readline)
	)

	if ! multilib_is_native_abi; then
		myconf+=(
			# deps not used for the library
			{DBUS,GLIB}_{CFLAGS,LIBS}=' '
		)
	fi

	# Missing flags: --enable-{sap,hidd,pand,dund,dbusoob,gatt}
	# Keep this in ./configure --help order!
	econf \
		--localstatedir=/var \
		--enable-network \
		--enable-serial \
		--enable-input \
		--enable-audio \
		--enable-service \
		--enable-health \
		--enable-pnat \
		$(multilib_native_use_enable gstreamer) \
		$(use_enable alsa) \
		$(multilib_native_use_enable usb) \
		$(multilib_native_use_enable usb cable) \
		--enable-tools \
		--enable-bccmd \
		$(use_enable pcmcia) \
		$(multilib_native_use_enable hid2hci) \
		--enable-dfutool \
		$(multilib_native_use_enable cups) \
		$(multilib_native_use_enable test-programs test) \
		--enable-datafiles \
		$(use_enable debug) \
		--enable-maemo6 \
		--enable-wiimote \
		--disable-hal \
		--with-ouifile=/usr/share/misc/oui.txt \
		--with-systemdunitdir="$(systemd_get_unitdir)"
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		default
	else
		emake -f Makefile -f - libs \
			<<<'libs: $(lib_LTLIBRARIES) $(alsa_LTLIBRARIES)'
	fi
}

multilib_src_test() {
	multilib_is_native_abi && default
}

multilib_src_install() {
	if multilib_is_native_abi; then
		emake DESTDIR="${D}" install
	else
		emake DESTDIR="${D}" \
			install-includeHEADERS \
			install-libLTLIBRARIES \
			install-alsaLTLIBRARIES \
			install-pkgconfigDATA
	fi

	if multilib_is_native_abi && use test-programs; then
		pushd test >/dev/null
		dobin simple-agent simple-service monitor-bluetooth
		newbin list-devices list-bluetooth-devices
		rm test-textfile.{c,o} || die #356529
		local b
		for b in hsmicro hsplay test-*; do
			newbin "${b}" bluez-"${b}"
		done
		insinto /usr/share/doc/${PF}/test-services
		doins service-*
		python_fix_shebang "${ED}"
		popd >/dev/null
	fi
}

multilib_src_install_all() {
	insinto /etc/bluetooth
	local d
	for d in input audio network serial; do
		doins ${d}/${d}.conf
	done

	newinitd "${FILESDIR}"/bluetooth-init.d-r2 bluetooth
	newinitd "${FILESDIR}"/rfcomm-init.d rfcomm
	newconfd "${FILESDIR}"/rfcomm-conf.d rfcomm

	readme.gentoo_create_doc

	prune_libtool_files --modules
}

pkg_postinst() {
	readme.gentoo_print_elog

	udevadm control --reload-rules

	has_version net-dialup/ppp || elog "To use dial up networking you must install net-dialup/ppp."

	if ! has_version sys-auth/consolekit && ! has_version sys-apps/systemd; then
		elog "Since you don't have sys-auth/consolekit neither sys-apps/systemd, you will only"
		elog "be able to run bluetooth clients as root. If you want to be able to run bluetooth clientes as"
		elog "a regular user, you need to enable the consolekit use flag for this package or"
		elog "to add the user to the plugdev group."
	fi
}
