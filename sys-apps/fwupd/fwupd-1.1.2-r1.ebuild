# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Package requires newer meson than eclass provides
MESON_AUTO_DEPEND="no"
PYTHON_COMPAT=( python3_{4,5,6} )

inherit meson python-single-r1 vala xdg-utils

DESCRIPTION="Aims to make updating firmware on Linux automatic, safe and reliable"
HOMEPAGE="https://fwupd.org"
SRC_URI="https://github.com/hughsie/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="colorhug dell doc +gpg +man nvme pkcs7 redfish systemd test thunderbolt uefi"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	dell? ( uefi )
"

RDEPEND="
	${PYTHON_DEPS}
	app-arch/libarchive:=
	dev-db/sqlite
	>=dev-libs/appstream-glib-0.7.4:=[introspection]
	>=dev-libs/glib-2.45.8:2
	dev-libs/libgpg-error
	dev-libs/libgudev:=
	>=dev-libs/libgusb-0.2.9[introspection]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
	>=net-libs/libsoup-2.51.92:2.4[introspection]
	>=sys-auth/polkit-0.103
	virtual/libelf:0=
	colorhug? ( >=x11-misc/colord-1.2.12:0= )
	dell? (
		sys-libs/efivar
		>=sys-libs/libsmbios-2.4.0
	)
	gpg? (
		app-crypt/gpgme
		dev-libs/libgpg-error
	)
	nvme? ( sys-libs/efivar )
	pkcs7? ( >=net-libs/gnutls-3.4.4.1:= )
	redfish? (
		dev-libs/json-glib
		sys-libs/efivar
	)
	systemd? ( >=sys-apps/systemd-211 )
	!systemd? ( >=sys-auth/consolekit-1.0.0 )
	thunderbolt? ( sys-apps/thunderbolt-software-user-space )
	uefi? (
		media-libs/fontconfig
		media-libs/freetype
		sys-boot/gnu-efi
		>=sys-libs/efivar-33
		x11-libs/cairo
	)
"
DEPEND="
	${RDEPEND}
	app-arch/gcab
	app-arch/libarchive
	>=dev-util/meson-0.41.0
	>=dev-util/ninja-1.7.2
	virtual/pkgconfig
	$(vala_depend)
	doc? ( dev-util/gtk-doc )
	man? ( app-text/docbook-sgml-utils )
	nvme? (	>=sys-kernel/linux-headers-4.4 )
	test? ( net-libs/gnutls[tools] )
"

# required for fwupd daemon to run.
# NOT a build time dependency. The build system does not check for dbus.
PDEPEND="sys-apps/dbus"

src_prepare() {
	default
	sed -e "s/'--create'/'--absolute-name', '--create'/" \
		-i data/tests/builder/meson.build || die
	sed -e "/'-Werror',/d" \
		-i plugins/uefi/efi/meson.build || die
	vala_src_prepare
}

src_configure() {
	xdg_environment_reset
	local emesonargs=(
		--localstatedir "${EPREFIX}"/var
		-Dconsolekit="$(usex systemd false true)"
		-Dgpg="$(usex gpg true false)"
		-Dgtkdoc="$(usex doc true false)"
		-Dman="$(usex man true false)"
		-Dpkcs7="$(usex pkcs7 true false)"
		-Dplugin_dell="$(usex dell true false)"
		-Dplugin_nvme="$(usex nvme true false)"
		-Dplugin_redfish="$(usex redfish true false)"
		-Dplugin_synaptics="$(usex dell true false)"
		-Dplugin_thunderbolt="$(usex thunderbolt true false)"
		-Dplugin_uefi="$(usex uefi true false)"
		-Dsystemd="$(usex systemd true false)"
		-Dtests="$(usex test true false)"
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	doinitd "${FILESDIR}"/${PN}
}

pkg_postinst() {
	elog "In case you are using openrc as init system"
	elog "and you're upgrading from <fwupd-1.1.0, you"
	elog "need to start the fwupd daemon via the openrc"
	elog "init script that comes with this package."
}
