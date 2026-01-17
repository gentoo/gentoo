# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit meson-multilib python-single-r1 tmpfiles udev

DESCRIPTION="PC/SC Architecture smartcard middleware library"
HOMEPAGE="https://pcsclite.apdu.fr https://github.com/LudovicRousseau/PCSC"
SRC_URI="https://pcsclite.apdu.fr/files/${P}.tar.xz"

# GPL-2 is there for the init script; everything else comes from
# upstream.
LICENSE="BSD GPL-3+ BSD-2 ISC GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
# This is called libusb so that it doesn't fool people in thinking that
# it is _required_ for USB support. Otherwise they'll disable udev and
# that's going to be worse.
IUSE="embedded libusb policykit selinux systemd +udev"
REQUIRED_USE="^^ ( udev libusb ) ${PYTHON_REQUIRED_USE}"

# No dependencies need the MULTILIB_DEPS because the libraries are actually
# standalone, the deps are only needed for the daemon itself.
DEPEND="
	libusb? ( virtual/libusb:1 )
	udev? ( virtual/libudev:= )
	policykit? ( >=sys-auth/polkit-0.111 )
	acct-group/openct
	acct-group/pcscd
	acct-user/pcscd
	${PYTHON_DEPS}
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-pcscd )
"
BDEPEND="
	app-alternatives/lex
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.4.0-change-setup-spy-script-location.patch
	"${FILESDIR}"/${PN}-2.4.0-systemd-fixes.patch
	"${FILESDIR}"/${PN}-2.4.0-systemd-sysusers-fixup.patch
)

multilib_src_configure() {
	local emesonargs=(
		-Dusbdropdir="${EPREFIX}"/usr/$(get_libdir)/readers/usb
		-Dipcdir=/run/pcscd
		-Dsystemdunit=system
		$(meson_native_use_bool embedded)
		$(meson_native_use_bool systemd libsystemd)
		$(meson_native_use_bool udev libudev)
		$(meson_native_use_bool libusb)
		$(meson_native_use_bool policykit polkit)
	)

	meson_src_configure
}

multilib_src_install_all() {
	einstalldocs
	dodoc HELP SECURITY

	newinitd "${FILESDIR}"/pcscd-init.7 pcscd
	dotmpfiles "${FILESDIR}"/pcscd.conf

	if use udev; then
		exeinto "$(get_udevdir)"
		newexe "${FILESDIR}"/pcscd-udev pcscd.sh

		insinto "$(get_udevdir)"/rules.d
		newins "${FILESDIR}"/99-pcscd-hotplug-r2.rules 99-pcscd-hotplug.rules
	fi

	python_fix_shebang "${ED}"/usr/bin/pcsc-spy

	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	elog "Starting from version 1.6.5, pcsc-lite will start as user nobody in"
	elog "the pcscd group, to avoid running as root."
	elog
	elog "This also means you need the newest drivers available so that the"
	elog "devices get the proper owner."
	elog
	elog "Furthermore, a conf.d file is no longer installed by default, as"
	elog "the default configuration does not require one. If you need to"
	elog "pass further options to pcscd, create a file and set the"
	elog "EXTRA_OPTS variable."
	elog

	if use udev; then
		elog "Hotplug support is provided by udev rules."
		elog "When using OpenRC you additionally need to tell it to hotplug"
		elog "pcscd by setting this variable in /etc/rc.conf:"
		elog
		elog "    rc_hotplug=\"pcscd\""
	fi

	tmpfiles_process pcscd.conf

	use udev && udev_reload
}

pkg_postrm() {
	use udev && udev_reload
}
