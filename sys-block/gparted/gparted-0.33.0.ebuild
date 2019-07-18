# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="Gnome Partition Editor"
HOMEPAGE="https://gparted.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+ FDL-1.2+"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE="btrfs cryptsetup dmraid f2fs fat hfs jfs kde mdadm ntfs policykit reiserfs reiser4 udf wayland xfs"

COMMON_DEPEND="
	!policykit? (
		kde? ( >=kde-plasma/kde-cli-tools-5.8.6-r1[kdesu] ) )
	policykit? ( >=sys-auth/polkit-0.102 )
	>=dev-cpp/glibmm-2.45.40:2
	>=dev-cpp/gtkmm-2.24:2.4
	>=dev-libs/glib-2:2
	>=sys-block/parted-3.2:=
	>=dev-libs/libsigc++-2.5.1:2
"
RDEPEND="${COMMON_DEPEND}
	>=sys-apps/util-linux-2.20
	>=sys-fs/e2fsprogs-1.41
	btrfs? ( sys-fs/btrfs-progs )
	cryptsetup? ( sys-fs/cryptsetup )
	dmraid? (
		>=sys-fs/lvm2-2.02.45
		sys-fs/dmraid
		sys-fs/multipath-tools )
	f2fs? ( sys-fs/f2fs-tools )
	fat? (
		sys-fs/dosfstools
		sys-fs/mtools )
	hfs? (
		sys-fs/diskdev_cmds
		virtual/udev
		sys-fs/hfsutils )
	jfs? ( sys-fs/jfsutils )
	mdadm? ( sys-fs/mdadm )
	ntfs? ( >=sys-fs/ntfs3g-2011.4.12[ntfsprogs] )
	reiserfs? ( sys-fs/reiserfsprogs )
	reiser4? ( sys-fs/reiser4progs )
	udf? ( sys-fs/udftools )
	wayland? ( x11-apps/xhost )
	xfs? ( sys-fs/xfsprogs sys-fs/xfsdump )
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/gnome-doc-utils
	>=dev-util/intltool-0.36.0
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		--enable-doc \
		--enable-online-resize \
		$(use_enable wayland xhost-root) \
		GKSUPROG=kdesu \
		ac_cv_prog_have_scrollkeeper_update=no
}

src_install() {
	gnome2_src_install

	local _ddir="${D}"/usr/share/applications
	local _bdir="${D}"/usr/bin

	if ! use policykit; then
		if use kde; then
			cp "${_ddir}"/gparted{,-kde}.desktop || die
			cp "${_bdir}"/gparted{,-kde} || die
			sed -i -e '/Exec/ s:gparted:gparted-kde:' "${_ddir}"/gparted-kde.desktop || die
			echo 'OnlyShowIn=KDE;' >> "${_ddir}"/gparted-kde.desktop || die
		fi
	else
		sed -i -e 's:kdesu::' "${_bdir}"/gparted || die
	fi
}
