# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_7,3_8,3_9} )

inherit python-single-r1 systemd udev multilib-minimal

DESCRIPTION="PC/SC Architecture smartcard middleware library"
HOMEPAGE="https://pcsclite.apdu.fr https://github.com/LudovicRousseau/PCSC"

SRC_URI="https://pcsclite.apdu.fr/files/${P}.tar.bz2"

# GPL-2 is there for the init script; everything else comes from
# upstream.
LICENSE="BSD ISC MIT GPL-3+ GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

# This is called libusb so that it doesn't fool people in thinking that
# it is _required_ for USB support. Otherwise they'll disable udev and
# that's going to be worse.
IUSE="doc embedded libusb policykit selinux systemd +udev"

REQUIRED_USE="^^ ( udev libusb ) ${PYTHON_REQUIRED_USE}"

# No dependencies need the MULTILIB_DEPS because the libraries are actually
# standalone, the deps are only needed for the daemon itself.
DEPEND="libusb? ( virtual/libusb:1 )
	udev? ( virtual/libudev:= )
	policykit? ( >=sys-auth/polkit-0.111 )
	acct-group/openct
	acct-group/pcscd
	acct-user/pcscd
	${PYTHON_DEPS}"

RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-pcscd )"

BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.8.11-polkit-pcscd.patch
)

DOCS=( AUTHORS HELP README SECURITY ChangeLog )

pkg_setup() {
	python-single-r1_pkg_setup
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--disable-maintainer-mode \
		--enable-usbdropdir="${EPREFIX}/usr/$(get_libdir)/readers/usb" \
		--enable-ipcdir=/run/pcscd \
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)" \
		$(use_enable doc documentation) \
		$(multilib_native_use_enable embedded) \
		$(multilib_native_use_enable systemd  libsystemd) \
		$(multilib_native_use_enable udev libudev) \
		$(multilib_native_use_enable libusb) \
		$(multilib_native_use_enable policykit polkit)
}

multilib_src_install_all() {
	einstalldocs

	newinitd "${FILESDIR}"/pcscd-init.7 pcscd

	if use udev; then
		exeinto "$(get_udevdir)"
		newexe "${FILESDIR}"/pcscd-udev pcscd.sh

		insinto "$(get_udevdir)"/rules.d
		newins "${FILESDIR}"/99-pcscd-hotplug-r1.rules 99-pcscd-hotplug.rules
	fi

	python_fix_shebang "${ED}"/usr/bin/pcsc-spy

	find "${ED}" -name '*.la' -delete || die
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
		elog "Hotplug support is provided by udev rules."
		elog "When using OpenRC you additionally need to tell it to hotplug"
		elog "pcscd by setting this variable in /etc/rc.conf:"
		elog ""
		elog "    rc_hotplug=\"pcscd\""
	fi
}
