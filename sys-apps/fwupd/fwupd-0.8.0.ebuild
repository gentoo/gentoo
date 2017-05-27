# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools udev systemd

DESCRIPTION="Aims to make updating firmware on Linux automatic, safe and reliable"
HOMEPAGE="http://www.fwupd.org"
SRC_URI="https://github.com/hughsie/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="colorhug dell doc elf nls uefi"

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

src_prepare() {
	default

	# Don't look for gtk-doc if doc USE is unset (breaks automake)
	if ! use doc ; then
		sed 's@^GTK_DOC_CHECK@#\0@' -i configure.ac || die
		sed '/gtk-doc\.make/d' \
			-i {.,docs/{libdfu,libfwupd}}/Makefile.am || die
	fi

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		# requires libtbtfwu which is not packaged yet
		--disable-thunderbolt
		--with-systemdunitdir="$(systemd_get_systemunitdir)"
		--with-udevrulesdir="$(get_udevdir)"/rules.d
		$(use_enable colorhug)
		$(use_enable dell)
		$(use_enable dell synaptics)
		$(use_enable elf libelf)
		$(use_enable nls)
		$(use_enable uefi)
	)
	econf "${myeconfargs[@]}"
}
