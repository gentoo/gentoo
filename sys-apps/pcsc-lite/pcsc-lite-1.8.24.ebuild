# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_6 )

inherit python-single-r1 systemd udev user multilib-minimal

DESCRIPTION="PC/SC Architecture smartcard middleware library"
HOMEPAGE="https://pcsclite.apdu.fr/"

SRC_URI="https://pcsclite.apdu.fr/files/${P}.tar.bz2"

# GPL-2 is there for the init script; everything else comes from
# upstream.
LICENSE="BSD ISC MIT GPL-3+ GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

# This is called libusb so that it doesn't fool people in thinking that
# it is _required_ for USB support. Otherwise they'll disable udev and
# that's going to be worse.
IUSE="python libusb policykit selinux systemd +udev"

REQUIRED_USE="^^ ( udev libusb ) \
	python? ( ${PYTHON_REQUIRED_USE} )"

# No dependencies need the MULTILIB_DEPS because the libraries are actually
# standalone, the deps are only needed for the daemon itself.
DEPEND="libusb? ( virtual/libusb:1 )
	udev? ( virtual/udev )
	policykit? ( >=sys-auth/polkit-0.111 )
	python? ( ${PYTHON_DEPS} )"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-pcscd )"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.8.11-polkit-pcscd.patch
)

DOCS=( AUTHORS HELP README SECURITY ChangeLog )

pkg_setup() {
	use python && python-single-r1_pkg_setup
	enewgroup openct # make sure it exists
	enewgroup pcscd
	enewuser pcscd -1 -1 /run/pcscd pcscd,openct
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--disable-maintainer-mode \
		--enable-usbdropdir="${EPREFIX}/usr/$(get_libdir)/readers/usb" \
		--enable-ipcdir=/run/pcscd \
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)" \
		$(multilib_native_use_enable systemd  libsystemd) \
		$(multilib_native_use_enable udev libudev) \
		$(multilib_native_use_enable libusb) \
		$(multilib_native_use_enable policykit polkit)
}

multilib_src_install_all() {
	einstalldocs

	newinitd "${FILESDIR}"/pcscd-init.7 pcscd

	if use udev; then
		insinto "$(get_udevdir)"/rules.d
		doins "${FILESDIR}"/99-pcscd-hotplug.rules
	fi

	for f in "${ED}/usr/bin/pcsc-spy"; do
		if use python; then
			python_fix_shebang "${f}"
		else
			rm "${f}"
		fi
	done
}

pkg_postinst() {
	elog "Starting from version 1.6.5, pcsc-lite will start as user nobody in"
	elog "the pcscd group, to avoid running as root."
	elog ""
	elog "This also means you need the newest drivers available so that the"
	elog "devices get the proper owner."
	elog ""
	elog "Furthermore, a conf.d file is no longer installed by default, as"
	elog "the default configuration does not require one. If you need to"
	elog "pass further options to pcscd, create a file and set the"
	elog "EXTRA_OPTS variable."
	elog ""
	if use udev; then
		elog "Hotplug support is provided by udev rules; you only need to tell"
		elog "the init system to hotplug it, by setting this variable in"
		elog "/etc/rc.conf:"
		elog ""
		elog "    rc_hotplug=\"pcscd\""
	fi
}
