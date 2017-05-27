# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson udev systemd

DESCRIPTION="Aims to make updating firmware on Linux automatic, safe and reliable"
HOMEPAGE="http://www.fwupd.org"
SRC_URI="https://github.com/hughsie/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="colorhug dell elf systemd uefi"

RDEPEND="
	app-crypt/gpgme
	dev-db/sqlite
	dev-libs/appstream-glib
	>=dev-libs/glib-2.45.8:2
	dev-libs/libgpg-error
	dev-libs/libgudev
	dev-libs/libgusb
	>=net-libs/libsoup-2.51.92:2.4
	>=sys-auth/polkit-0.103
	colorhug? ( >=x11-misc/colord-1.2.12:0= )
	dell? (
		sys-libs/efivar
		>=sys-libs/libsmbios-2.3.0
	)
	elf? ( dev-libs/libelf )
	systemd? ( sys-apps/systemd )
	uefi? ( >=sys-apps/fwupdate-5 )
"
DEPEND="
	${RDEPEND}
	app-arch/gcab
	app-arch/libarchive
	app-text/docbook-sgml-utils
	dev-util/gtk-doc
	virtual/pkgconfig
"

REQUIRED_USE="dell? ( uefi )"

PATCHES=(
	"${FILESDIR}/${PN}-0.9-polkit_its_files.patch"
	"${FILESDIR}/${PN}-0.9.2-no_systemd.patch"
)

src_configure() {
	local emesonargs=(
		# requires libtbtfwu which is not packaged yet
		-Denable-thunderbolt=false
		-Dwith-systemd="$(usex systemd true false)"
		-Dwith-udevrulesdir="$(get_udevdir)"/rules.d
		-Denable-colorhug="$(usex colorhug true false)"
		-Denable-dell="$(usex dell true false)"
		-Denable-libelf="$(usex elf true false)"
		-Denable-uefi="$(usex uefi true false)"
	)
	meson_src_configure
}
