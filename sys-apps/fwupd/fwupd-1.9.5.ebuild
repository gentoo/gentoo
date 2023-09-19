# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit meson python-single-r1 vala udev xdg

DESCRIPTION="Aims to make updating firmware on Linux automatic, safe and reliable"
HOMEPAGE="https://fwupd.org"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="amt +archive bash-completion bluetooth cbor dell elogind fastboot flashrom gnutls gtk-doc +gusb introspection logitech lzma minimal modemmanager nvme policykit spi +sqlite synaptics systemd test test-full tpm uefi"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	^^ ( elogind minimal systemd )
	dell? ( uefi )
	fastboot? ( gusb )
	logitech? ( gusb )
	minimal? ( !introspection )
	modemmanager? ( gusb )
	spi? ( lzma )
	synaptics? ( gnutls )
	test? ( archive gusb )
	test-full? ( test )
	uefi? ( gnutls )
"
RESTRICT="!test? ( test )"

BDEPEND="$(vala_depend)
	>=dev-util/meson-0.60.0
	virtual/pkgconfig
	gtk-doc? (
		$(python_gen_cond_dep '
			>=dev-python/markdown-3.2[${PYTHON_USEDEP}]
		')
		>=dev-util/gi-docgen-2021.1
	)
	bash-completion? ( >=app-shells/bash-completion-2.0 )
	introspection? ( dev-libs/gobject-introspection )
	test? (
		net-libs/gnutls[tools]
		test-full? ( dev-util/umockdev )
	)
"
COMMON_DEPEND="${PYTHON_DEPS}
	>=app-arch/gcab-1.0
	app-arch/xz-utils
	>=dev-libs/glib-2.68:2
	>=dev-libs/json-glib-1.6.0
	>=dev-libs/libgudev-232:=
	>=dev-libs/libjcat-0.1.4[gpg,pkcs7]
	>=dev-libs/libxmlb-0.3.6:=[introspection?]
	$(python_gen_cond_dep '
		dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
	')
	>=net-misc/curl-7.62.0
	archive? ( app-arch/libarchive:= )
	cbor? ( >=dev-libs/libcbor-0.7.0:= )
	dell? (
		>=app-crypt/tpm2-tss-2.0
		>=sys-libs/libsmbios-2.4.0
	)
	elogind? ( >=sys-auth/elogind-211 )
	flashrom? ( >=sys-apps/flashrom-1.2-r3 )
	gnutls? ( >=net-libs/gnutls-3.6.0 )
	gusb? ( >=dev-libs/libgusb-0.3.8[introspection?] )
	logitech? ( dev-libs/protobuf-c:= )
	lzma? ( app-arch/xz-utils )
	modemmanager? ( net-misc/modemmanager[mbim,qmi] )
	policykit? ( >=sys-auth/polkit-0.114 )
	sqlite? ( dev-db/sqlite )
	systemd? ( >=sys-apps/systemd-211 )
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
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.9.4-fragile_tests.patch
)

pkg_pretend() {
	if [[ ${MERGE_TYPE} != buildonly ]]; then
		if use test-full && has sandbox ${FEATURES}; then
			ewarn "Certain ${PN} tests are fragile with sandboxing enabled,"
			ewarn "see https://github.com/fwupd/fwupd/issues/1414."
			ewarn "When in doubt, emerge ${PN} with USE=-test-full."
		fi
	fi
}

src_prepare() {
	default

	vala_setup

	sed -e "/install_dir.*'doc'/s/doc/gtk-doc/" \
		-i docs/meson.build || die

	python_fix_shebang "${S}"/contrib/*.py
}

src_configure() {
	local plugins=(
		-Dplugin_gpio="enabled"
		$(meson_feature amt plugin_intel_me)
		$(meson_feature dell plugin_dell)
		$(meson_feature fastboot plugin_fastboot)
		$(meson_feature flashrom plugin_flashrom)
		$(meson_feature gusb plugin_uf2)
		$(meson_feature logitech plugin_logitech_bulkcontroller)
		$(meson_feature modemmanager plugin_modem_manager)
		$(meson_feature nvme plugin_nvme)
		$(meson_use spi plugin_intel_spi)
		$(meson_feature synaptics plugin_synaptics_mst)
		$(meson_feature synaptics plugin_synaptics_rmi)
		$(meson_feature tpm plugin_tpm)
		$(meson_feature uefi plugin_uefi_capsule)
		$(meson_use uefi plugin_uefi_capsule_splash)
		$(meson_feature uefi plugin_uefi_pk)
	)
	if use ppc64 || use riscv ; then
		plugins+=( -Dplugin_msr="disabled" )
	fi

	local emesonargs=(
		--localstatedir "${EPREFIX}"/var
		-Dbuild="$(usex minimal standalone all)"
		-Dconsolekit="disabled"
		-Dcurl="enabled"
		-Defi_binary="false"
		-Dman="true"
		-Dsupported_build="enabled"
		-Dudevdir="${EPREFIX}$(get_udevdir)"
		$(meson_feature archive libarchive)
		$(meson_use bash-completion bash_completion)
		$(meson_feature bluetooth bluez)
		$(meson_feature cbor)
		$(meson_feature elogind)
		$(meson_feature gnutls)
		$(meson_feature gtk-doc docs)
		$(meson_feature gusb)
		$(meson_feature lzma)
		$(meson_feature introspection)
		$(meson_feature policykit polkit)
		$(meson_feature sqlite)
		$(meson_feature systemd)
		$(meson_use test tests)
		$(meson_use test-full)

		${plugins[@]}
	)
	use uefi && emesonargs+=( -Defi_os_dir="gentoo" )
	export CACHE_DIRECTORY="${T}"
	meson_src_configure
}

src_test() {
	LC_ALL="C" meson_src_test
}

src_install() {
	meson_src_install

	if ! use minimal ; then
		newinitd "${FILESDIR}"/${PN}-r2 ${PN}
	fi

	if use test; then
		# Preventing tests from being installed in the first place is a moving target,
		# just axe them all afterwards.
		rm -rf "${ED}"/etc/fwupd/remotes.d/fwupd-tests.conf \
			"${ED}"/usr/libexec/installed-tests \
			"${ED}"/usr/share/fwupd/device-tests \
			"${ED}"/usr/share/fwupd/host-emulate.d/thinkpad-p1-iommu.json.gz \
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
