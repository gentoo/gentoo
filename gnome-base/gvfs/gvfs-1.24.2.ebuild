# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools bash-completion-r1 eutils gnome2

DESCRIPTION="Virtual filesystem implementation for gio"
HOMEPAGE="https://git.gnome.org/browse/gvfs"

LICENSE="LGPL-2+"
SLOT="0"

IUSE="afp archive bluray cdda fuse gnome-online-accounts gphoto2 gtk +http ios libsecret mtp nfs samba systemd test +udev udisks zeroconf"
REQUIRED_USE="
	cdda? ( udev )
	mtp? ( udev )
	udisks? ( udev )
	systemd? ( udisks )
"
KEYWORDS="alpha amd64 ~arm ~ia64 ~mips ~ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~sparc-solaris ~x86-solaris"

# Can use libgphoto-2.5.0 as well. Automagic detection.
RDEPEND="
	>=dev-libs/glib-2.43.2:2
	sys-apps/dbus
	dev-libs/libxml2:2
	net-misc/openssh
	afp? ( >=dev-libs/libgcrypt-1.2.2:0= )
	archive? ( app-arch/libarchive:= )
	bluray? ( media-libs/libbluray )
	fuse? ( >=sys-fs/fuse-2.8.0 )
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.7.1 )
	gphoto2? ( >=media-libs/libgphoto2-2.4.7:= )
	gtk? ( >=x11-libs/gtk+-3.0:3 )
	http? ( >=net-libs/libsoup-2.42:2.4 )
	ios? (
		>=app-pda/libimobiledevice-1.1.5:=
		>=app-pda/libplist-1:= )
	libsecret? ( app-crypt/libsecret )
	mtp? ( >=media-libs/libmtp-1.1.6 )
	nfs? ( >=net-fs/libnfs-1.9.7 )
	samba? ( || ( >=net-fs/samba-3.4.6[smbclient] >=net-fs/samba-4[client] ) )
	systemd? ( sys-apps/systemd:0= )
	udev? (
		cdda? ( dev-libs/libcdio-paranoia )
		virtual/libgudev:=
		virtual/libudev:= )
	udisks? ( >=sys-fs/udisks-1.97:2 )
	zeroconf? ( >=net-dns/avahi-0.6 )
"
DEPEND="${RDEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	dev-util/gdbus-codegen
	dev-util/gtk-doc-am
	test? (
		>=dev-python/twisted-core-12.3.0
		|| (
			net-analyzer/netcat
			net-analyzer/netcat6 ) )
	!udev? ( >=dev-libs/libgcrypt-1.2.2:0 )
"
# libgcrypt.m4, provided by libgcrypt, needed for eautoreconf, bug #399043
# test dependencies needed per https://bugzilla.gnome.org/700162

# Tests with multiple failures, this is being handled upstream at:
# https://bugzilla.gnome.org/700162
RESTRICT="test"

src_prepare() {
	DOCS="AUTHORS ChangeLog NEWS MAINTAINERS README TODO" # ChangeLog.pre-1.2 README.commits

	if ! use udev; then
		sed -e 's/gvfsd-burn/ /' \
			-e 's/burn.mount.in/ /' \
			-e 's/burn.mount/ /' \
			-i daemon/Makefile.am || die

		# Uncomment when eautoreconf stops being needed always
		eautoreconf
	fi

	gnome2_src_prepare
}

src_configure() {
	# --enable-documentation installs man pages
	# --disable-obexftp, upstream bug #729945
	gnome2_src_configure \
		--enable-bash-completion \
		--with-bash-completion-dir="$(get_bashcompdir)" \
		--disable-gdu \
		--disable-hal \
		--with-dbus-service-dir="${EPREFIX}"/usr/share/dbus-1/services \
		--enable-documentation \
		$(use_enable afp) \
		$(use_enable archive) \
		$(use_enable bluray) \
		$(use_enable cdda) \
		$(use_enable fuse) \
		$(use_enable gnome-online-accounts goa) \
		$(use_enable gphoto2) \
		$(use_enable gtk) \
		$(use_enable ios afc) \
		$(use_enable mtp libmtp) \
		$(use_enable nfs) \
		$(use_enable udev) \
		$(use_enable udev gudev) \
		$(use_enable http) \
		$(use_enable libsecret keyring) \
		$(use_enable samba) \
		$(use_enable systemd libsystemd-login) \
		$(use_enable udisks udisks2) \
		$(use_enable zeroconf avahi)
}
