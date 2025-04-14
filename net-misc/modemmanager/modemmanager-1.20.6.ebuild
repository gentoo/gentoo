# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..13} )
inherit bash-completion-r1 meson python-any-r1 optfeature systemd udev vala xdg

DESCRIPTION="Modem and mobile broadband management libraries"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/ModemManager/ https://gitlab.freedesktop.org/mobile-broadband/ModemManager"
SRC_URI="https://gitlab.freedesktop.org/mobile-broadband/ModemManager/-/archive/${PV}/ModemManager-${PV}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0/1" # subslot = dbus interface version, i.e. N in org.freedesktop.ModemManager${N}
KEYWORDS="~alpha amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv ~sparc x86"

IUSE="elogind gtk-doc +introspection +mbim policykit +qmi +qrtr selinux systemd test +udev vala"
REQUIRED_USE="
	?? ( elogind systemd )
	qrtr? ( qmi )
	vala? ( introspection )
"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/glib-2.56.0:2
	udev? ( >=dev-libs/libgudev-232:= )
	introspection? ( >=dev-libs/gobject-introspection-1.38:= )
	mbim? ( >=net-libs/libmbim-1.28.0 )
	policykit? ( >=sys-auth/polkit-0.106[introspection?] )
	qmi? ( >=net-libs/libqmi-1.32.0:=[qrtr?] )
	qrtr? ( >=net-libs/libqrtr-glib-1.0.0:= )
	elogind? ( sys-auth/elogind )
	systemd? ( >=sys-apps/systemd-209 )
"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-modemmanager )
"
BDEPEND="
	dev-util/gdbus-codegen
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-python/dbus-python[${PYTHON_USEDEP}]
			dev-python/pygobject:3[${PYTHON_USEDEP}]
		')
	)
	vala? ( $(vala_depend) )
"

S="${WORKDIR}/ModemManager-${PV}"

python_check_deps() {
	python_has_version "dev-python/dbus-python[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/pygobject:3[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	use vala && vala_setup
	default
}

src_configure() {
	# Let's avoid BuildRequiring bash-completion, install it manually
	local emesonargs=(
		-Dbash_completion=false
		$(meson_use gtk-doc gtk_doc)
		$(meson_use introspection)

		$(meson_use udev)
		-Dudevdir="${EPREFIX}$(get_udevdir)"
		-Dsystemdsystemunitdir="$(systemd_get_systemunitdir)"

		$(meson_use systemd systemd_journal)

		-Dpolkit=$(usex policykit permissive no)

		$(meson_use mbim)
		$(meson_use qmi)
		$(meson_use qrtr)

		$(meson_use vala vapi)
	)
	if use systemd || use elogind; then
		emesonargs+=(-Dsystemd_suspend_resume=true)
	else
		emesonargs+=(-Dsystemd_suspend_resume=false)
	fi
	meson_src_configure
}

src_install() {
	meson_src_install
	newinitd "${FILESDIR}/modemmanager.initd" modemmanager
	newbashcomp cli/mmcli-completion mmcli
}

pkg_postinst() {
	xdg_pkg_postinst

	if ! use udev; then
		ewarn "You have built ModemManager without udev support. You may have to teach it"
		ewarn "about your modem port manually."
	fi

	use udev && udev_reload

	systemd_reenable ModemManager.service

	optfeature "the case your modem shows up as a storage drive" sys-apps/usb_modeswitch
}

pkg_postrm() {
	xdg_pkg_postrm
	use udev && udev_reload
}
