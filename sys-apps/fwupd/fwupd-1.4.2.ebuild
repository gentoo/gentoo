# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit linux-info meson python-single-r1 vala xdg toolchain-funcs

DESCRIPTION="Aims to make updating firmware on Linux automatic, safe and reliable"
HOMEPAGE="https://fwupd.org"
SRC_URI="https://github.com/hughsie/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="agent amt consolekit dell gtk-doc elogind minimal introspection +man nvme redfish synaptics systemd test thunderbolt tpm uefi"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	^^ ( consolekit elogind minimal systemd )
	dell? ( uefi )
	minimal? ( !introspection )
"
RESTRICT="!test? ( test )"

BDEPEND="$(vala_depend)
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
	introspection? ( dev-libs/gobject-introspection )
	man? (
		app-text/docbook-sgml-utils
		sys-apps/help2man
	)
	test? (
		thunderbolt? ( dev-util/umockdev )
		net-libs/gnutls[tools]
	)
"
DEPEND="${PYTHON_DEPS}
	>=app-arch/gcab-1.0
	app-arch/libarchive:=
	dev-db/sqlite
	>=dev-libs/glib-2.45.8:2
	dev-libs/json-glib
	dev-libs/libgpg-error
	dev-libs/libgudev:=
	>=dev-libs/libgusb-0.2.9[introspection?]
	>=dev-libs/libjcat-0.1.0[gpg,pkcs7]
	>=dev-libs/libxmlb-0.1.13
	$(python_gen_cond_dep '
		dev-python/pillow[${PYTHON_MULTI_USEDEP}]
		dev-python/pycairo[${PYTHON_MULTI_USEDEP}]
		dev-python/pygobject:3[cairo,${PYTHON_MULTI_USEDEP}]
	')
	>=net-libs/libsoup-2.51.92:2.4[introspection?]
	virtual/libelf:0=
	virtual/udev
	consolekit? ( >=sys-auth/consolekit-1.0.0 )
	dell? (
		sys-libs/efivar
		>=sys-libs/libsmbios-2.4.0
	)
	elogind? ( sys-auth/elogind )
	!minimal? (
		>=sys-auth/polkit-0.103
	)
	nvme? ( sys-libs/efivar )
	redfish? ( sys-libs/efivar )
	systemd? ( >=sys-apps/systemd-211 )
	tpm? ( app-crypt/tpm2-tss )
	uefi? (
		app-crypt/tpm2-tss
		media-libs/fontconfig
		media-libs/freetype
		sys-boot/gnu-efi
		sys-boot/efibootmgr
		>=sys-libs/efivar-33
		x11-libs/cairo
	)
"
# Block sci-chemistry/chemical-mime-data for bug #701900
RDEPEND="
	!<sci-chemistry/chemical-mime-data-0.1.94-r4
	${DEPEND}
	sys-apps/dbus
"

PATCHES=(
	"${FILESDIR}/${PN}-1.3.9-logind_plugin.patch"
)

pkg_setup() {
	python-single-r1_pkg_setup
	if use nvme; then
		kernel_is -ge 4 4 || die "NVMe support requires kernel >= 4.4"
	fi
}

src_prepare() {
	default
	# c.f. https://github.com/fwupd/fwupd/issues/1414
	sed -e "/test('thunderbolt-self-test', e, env: test_env, timeout : 120)/d" \
		-i plugins/thunderbolt/meson.build || die
	vala_src_prepare
}

src_configure() {
	local emesonargs=(
		--localstatedir "${EPREFIX}"/var
		-Dbuild="$(usex minimal standalone all)"
		$(meson_use agent)
		$(meson_use amt plugin_amt)
		$(meson_use consolekit)
		$(meson_use dell plugin_dell)
		$(meson_use elogind)
		$(meson_use gtk-doc gtkdoc)
		$(meson_use man)
		$(meson_use nvme plugin_nvme)
		$(meson_use redfish plugin_redfish)
		$(meson_use synaptics plugin_synaptics)
		$(meson_use systemd)
		$(meson_use test tests)
		$(meson_use thunderbolt plugin_thunderbolt)
		$(meson_use tpm plugin_tpm)
		$(meson_use uefi plugin_uefi)
		# Although our sys-apps/flashrom package now provides
		# libflashrom.a, meson still can't find it
		-Dplugin_flashrom="false"
		# Dependencies are not available (yet?)
		-Dplugin_modem_manager="false"
	)
	export CACHE_DIRECTORY="${T}"
	meson_src_configure
}

src_install() {
	meson_src_install

	if ! use minimal ; then
		sed "s@%SEAT_MANAGER%@$(usex elogind elogind consolekit)@" \
			"${FILESDIR}"/${PN}-r1 \
			> "${T}"/${PN} || die
		doinitd "${T}"/${PN}

		if ! use systemd ; then
			# Don't timeout when fwupd is running (#673140)
			sed '/^IdleTimeout=/s@=[[:digit:]]\+@=0@' \
				-i "${ED}"/etc/${PN}/daemon.conf || die
		fi
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "In case you are using openrc as init system"
	elog "and you're upgrading from <fwupd-1.1.0, you"
	elog "need to start the fwupd daemon via the openrc"
	elog "init script that comes with this package."
}
