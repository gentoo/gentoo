# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_4 python3_5 python3_6 )

inherit meson python-single-r1 xdg-utils

DESCRIPTION="Aims to make updating firmware on Linux automatic, safe and reliable"
HOMEPAGE="https://fwupd.org"
SRC_URI="https://github.com/hughsie/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="colorhug dell doc elf +man systemd test uefi uefi_labels"
REQUIRED_USE="uefi_labels? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	app-crypt/gpgme
	dev-db/sqlite
	>=dev-libs/appstream-glib-0.6.13[introspection]
	>=dev-libs/glib-2.45.8:2
	dev-libs/libgpg-error
	dev-libs/libgudev
	>=dev-libs/libgusb-0.2.9[introspection]
	>=net-libs/libsoup-2.51.92:2.4
	>=sys-auth/polkit-0.103
	colorhug? ( >=x11-misc/colord-1.2.12:0= )
	dell? (
		sys-libs/efivar
		>=sys-libs/libsmbios-2.3.3
	)
	elf? ( virtual/libelf:0= )
	systemd? ( >=sys-apps/systemd-231 )
	!systemd? ( >=sys-auth/consolekit-1.0.0 )
	uefi? ( >=sys-apps/fwupdate-5 )
	uefi_labels? (
		${PYTHON_DEPS}
		dev-python/pycairo[${PYTHON_USEDEP}]
		dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		x11-libs/pango
		x11-libs/cairo
		media-libs/freetype
		media-libs/fontconfig
		media-fonts/dejavu
		media-fonts/source-han-sans
	)
"
DEPEND="
	${RDEPEND}
	app-arch/gcab
	app-arch/libarchive
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )
	man? ( app-text/docbook-sgml-utils )
	test? ( net-libs/gnutls[tools] )
"

REQUIRED_USE="dell? ( uefi )"

src_prepare() {
	default
	sed -i -e "s/'--create'/'--absolute-name', '--create'/" data/tests/builder/meson.build || die
}

src_configure() {
	xdg_environment_reset
	local emesonargs=(
		-Denable-colorhug="$(usex colorhug true false)"
		-Denable-consolekit="$(usex systemd false true)"
		-Denable-dell="$(usex dell true false)"
		-Denable-doc="$(usex doc true false)"
		-Denable-man="$(usex man true false)"
		-Denable-libelf="$(usex elf true false)"
		-Denable-systemd="$(usex systemd true false)"
		# requires libtbtfwu which is not packaged yet
		-Denable-thunderbolt=false
		-Denable-tests="$(usex test true false)"
		-Denable-uefi="$(usex uefi true false)"
		-Denable-uefi-labels="$(usex uefi_labels true false)"
	)
	meson_src_configure
}
