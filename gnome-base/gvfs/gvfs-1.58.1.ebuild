# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TMPFILES_OPTIONAL=1
inherit gnome.org gnome2-utils meson systemd tmpfiles xdg

DESCRIPTION="Virtual filesystem implementation for GIO"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gvfs"

LICENSE="LGPL-2+"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="afp archive bluray cdda cdr elogind fuse +gcr google keyring gnome-online-accounts gphoto2 +http ios +man mtp nfs onedrive policykit samba +sftp systemd test +udev udisks zeroconf"
RESTRICT="!test? ( test )"
# elogind/systemd only relevant to udisks (in v1.38.1)
REQUIRED_USE="
	?? ( elogind systemd )
	cdda? ( udev )
	google? ( gnome-online-accounts )
	gphoto2? ( udev )
	mtp? ( udev )
	onedrive? ( gnome-online-accounts )
	udisks? ( udev )
"

RDEPEND="
	>=dev-libs/glib-2.83.0:2
	>=gnome-base/gsettings-desktop-schemas-3.33.0
	sys-apps/dbus
	afp? ( >=dev-libs/libgcrypt-1.2.2:0= )
	archive? ( app-arch/libarchive:= )
	bluray? ( media-libs/libbluray:= )
	cdda? (
		dev-libs/libcdio:0=
		>=dev-libs/libcdio-paranoia-0.78.2:=
	)
	elogind? ( >=sys-auth/elogind-229:0= )
	fuse? (
		>=sys-fs/fuse-3.0.0:3=
		virtual/tmpfiles
	)
	gcr? ( app-crypt/gcr:4= )
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.53.1:= )
	google? ( >=dev-libs/libgdata-0.18.0:=[crypt,gnome-online-accounts] )
	gphoto2? ( >=media-libs/libgphoto2-2.5.0:= )
	http? (
		dev-libs/libxml2:2=
		>=net-libs/libsoup-3.0.0:3.0
	)
	ios? (
		>=app-pda/libimobiledevice-1.2:=
		>=app-pda/libplist-1:=
	)
	keyring? ( app-crypt/libsecret )
	mtp? (
		virtual/libusb:1
		>=media-libs/libmtp-1.1.15:=
	)
	nfs? ( >=net-fs/libnfs-1.9.8:= )
	onedrive? ( >=net-libs/msgraph-0.3.0:= )
	policykit? (
		>=sys-auth/polkit-0.114
		sys-libs/libcap
	)
	samba? ( >=net-fs/samba-4[client] )
	sftp? ( virtual/openssh )
	systemd? ( >=sys-apps/systemd-206:0= )
	udev? ( >=dev-libs/libgudev-147:= )
	udisks? ( >=sys-fs/udisks-1.97:2 )
	zeroconf? ( >=net-dns/avahi-0.6[dbus] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-util/gdbus-codegen-2.80.5-r1
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	man? (
		app-text/docbook-xsl-stylesheets
		app-text/docbook-xml-dtd:4.2
		dev-libs/libxslt
	)
	test? ( dev-libs/libgdata )
"

src_configure() {
	local enable_logind="false"
	if use systemd || use elogind; then
		enable_logind="true"
	fi

	# currently HAVE_GCRYPT and linkage only used with afp; check it on big
	# bumps (grep for HAVE_GCRYPT and enable_gcrypt); adjust depends if changes
	local enable_gcrypt="false"
	if use afp; then
		enable_gcrypt="true"
	fi

	# currently HAVE_LIBUSB and linkage only used with mtp; check it on big
	# bumps (grep for HAVE_LIBUSB and enable_libusb); adjust depends if changes
	local enable_libusb="false"
	if use mtp; then
		enable_libusb="true"
	fi

	local emesonargs=(
		-Dsystemduserunitdir="$(systemd_get_userunitdir)"
		-Dtmpfilesdir="${EPREFIX}"/usr/lib/tmpfiles.d
		$(meson_use policykit admin)
		$(meson_use ios afc)
		$(meson_use afp)
		$(meson_use archive)
		$(meson_use bluray)
		$(meson_use cdr burn)
		$(meson_use cdda)
		-Ddeprecated_apis=false
		$(meson_use zeroconf dnssd)
		$(meson_use fuse)
		$(meson_use gcr)
		$(meson_use gnome-online-accounts goa)
		$(meson_use google)
		$(meson_use gphoto2)
		$(meson_use udev gudev)
		$(meson_use http)
		$(meson_use keyring keyring)
		$(meson_use man)
		$(meson_use mtp)
		$(meson_use nfs)
		$(meson_use onedrive)
		$(meson_use samba smb)
		$(meson_use sftp)
		$(meson_use udisks udisks2)
		-Dgcrypt=${enable_gcrypt}
		-Dlogind=${enable_logind}
		-Dlibusb=${enable_libusb}
		# wouldn't install any of it as of 1.38.1; some tests need it,
		# but they aren't automated tests in 1.38.1
		-Ddevel_utils=false
		-Dinstalled_tests=false
		-Dunit_tests=false
		-Dprivileged_group=wheel
		# wsdd is currently masked
		-Dwsdd=false
	)
	meson_src_configure
}

pkg_postinst() {
	if use fuse; then
		tmpfiles_process gvfsd-fuse-tmpfiles.conf
	fi

	xdg_pkg_postinst
	gnome2_schemas_update
	gnome2_giomodule_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
	gnome2_giomodule_cache_update
}
