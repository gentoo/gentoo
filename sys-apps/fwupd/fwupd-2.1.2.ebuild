# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/hughsie.asc
inherit meson python-single-r1 vala verify-sig udev xdg

DESCRIPTION="Aims to make updating firmware on Linux automatic, safe and reliable"
HOMEPAGE="https://fwupd.org"
SRC_URI="
	https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.xz
	verify-sig? ( https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.xz.asc )
"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="amdgpu bash-completion bluetooth elogind flashrom gnutls gtk-doc introspection minimal modemmanager policykit seccomp systemd test tpm readline uefi"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	?? ( elogind systemd )
	minimal? ( !introspection )
	seccomp? ( systemd )
	uefi? ( gnutls )
"
# DBus permission failures in 2.0.20 and then other new issues in 2.1.1
# Likely needs wrangling for ebuild environment
RESTRICT="!test? ( test ) test"

COMMON_DEPEND="
	${PYTHON_DEPS}
	>=app-arch/gcab-1.0
	app-arch/xz-utils
	dev-db/sqlite:3
	>=dev-libs/glib-2.72:2
	>=dev-libs/libjcat-0.2.0[pkcs7]
	>=dev-libs/libxmlb-0.3.19:=[introspection?]
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
	net-libs/libmnl:=
	>=net-misc/curl-7.62.0
	sys-apps/util-linux
	virtual/libusb:1
	virtual/zlib:=

	amdgpu? (
		>=x11-libs/libdrm-2.4.113[video_cards_amdgpu]
	)
	elogind? ( >=sys-auth/elogind-211 )
	flashrom? ( >=sys-apps/flashrom-1.2-r3 )
	gnutls? ( >=net-libs/gnutls-3.6.0:= )
	modemmanager? ( >=net-misc/modemmanager-1.22.0[mbim,qmi] )
	policykit? ( >=sys-auth/polkit-0.114 )
	readline? ( sys-libs/readline:= )
	seccomp? ( sys-apps/systemd[seccomp] )
	systemd? ( >=sys-apps/systemd-249:= )
	tpm? ( app-crypt/tpm2-tss:= )
	uefi? (
		sys-apps/fwupd-efi
		sys-boot/efibootmgr
		sys-fs/udisks
		sys-libs/efivar
	)
"
RDEPEND="
	${COMMON_DEPEND}
	sys-apps/dbus
"

DEPEND="
	${COMMON_DEPEND}
	x11-libs/pango[introspection]
	virtual/os-headers
"
BDEPEND="
	$(vala_depend)
	$(python_gen_cond_dep '
		dev-python/jinja2[${PYTHON_USEDEP}]
	')
	>=dev-build/meson-1.3.2
	sys-apps/hwdata
	virtual/pkgconfig
	gtk-doc? (
		$(python_gen_cond_dep '
			>=dev-python/markdown-3.2[${PYTHON_USEDEP}]
		')
		>=dev-util/gi-docgen-2021.1
	)
	bash-completion? ( >=app-shells/bash-completion-2.0 )
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2 )
	test? (
		net-libs/gnutls[tools]
	)
	uefi? (
		$(python_gen_cond_dep '
			dev-python/pygobject:3[cairo]
		')
	)
	verify-sig? ( sec-keys/openpgp-keys-hughsie )
"

src_prepare() {
	default

	vala_setup

	sed -i -e "/install_dir.*'doc'/s/doc/gtk-doc/" \
		docs/meson.build || die

	python_fix_shebang "${S}"/contrib/*.py
}

src_configure() {
	# Automagic dependency on sys-apps/uswid for SBOMs
	local native_file="${T}"/meson.${CHOST}.${ABI}.ini.local
	cat >> ${native_file} <<-EOF || die
	[binaries]
	uswid='uswid-falseified'
	EOF

	local plugins=(
		$(meson_feature flashrom plugin_flashrom)
		$(meson_feature amdgpu libdrm)
		$(meson_feature modemmanager plugin_modem_manager)
		$(meson_feature tpm hsi)
		$(meson_use uefi plugin_uefi_capsule_splash)
	)

	local emesonargs=(
		--native-file "${native_file}"
		--localstatedir "${EPREFIX}"/var

		-Dbuild="$(usex minimal standalone all)"
		-Dblkid=enabled
		-Defi_binary="false"
		-Defi_os_dir="gentoo"
		-Dman="true"
		-Dsupported_build="enabled"
		-Dsystemd_unit_user=""
		# Unpackaged dependency
		-Dpassim=disabled
		-Dlibmnl=enabled

		$(meson_use bash-completion bash_completion)
		$(meson_feature bluetooth bluez)
		$(meson_feature gnutls)
		$(meson_feature gtk-doc docs)
		$(meson_feature introspection)
		$(meson_feature policykit polkit)
		$(meson_feature readline)
		$(meson_feature systemd)
		$(meson_use test tests)
		$(meson_feature test umockdev_tests)

		${plugins[@]}
	)

	if use elogind || use systemd ; then
		emesonargs+=( -Dlogind=enabled )
	else
		emesonargs+=( -Dlogind=disabled )
	fi

	export CACHE_DIRECTORY="${T}"
	meson_src_configure
}

src_test() {
	LC_ALL="C.UTF-8" meson_src_test
}

src_install() {
	meson_src_install

	if ! use minimal ; then
		newinitd "${FILESDIR}"/${PN}-r2 ${PN}
	fi

	if use test; then
		# Preventing tests from being installed in the first place is a moving target,
		# just axe them all afterwards.
		rm -rf \
			"${ED}"/usr/libexec/installed-tests \
			"${ED}"/usr/share/fwupd/device-tests \
			"${ED}"/usr/share/fwupd/host-emulate.d/thinkpad-p1-iommu.json.gz \
			"${ED}"/usr/share/fwupd/remotes.d/fwupd-tests.conf \
			"${ED}"/usr/share/installed-tests \
		|| die
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	use minimal || udev_reload
}

pkg_postrm() {
	xdg_pkg_postrm
	use minimal || udev_reload
}
