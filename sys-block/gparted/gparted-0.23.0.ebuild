# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Gnome Partition Editor"
HOMEPAGE="http://gparted.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2+ FDL-1.2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~x86"
IUSE="btrfs dmraid f2fs fat hfs jfs kde mdadm ntfs policykit reiserfs reiser4 xfs"

# FIXME: add gpart support
COMMON_DEPEND="
	>=dev-cpp/glibmm-2.14:2
	>=dev-cpp/gtkmm-2.22:2.4
	>=dev-libs/glib-2:2
	>=sys-block/parted-3.2:=
"
RDEPEND="${COMMON_DEPEND}
	!policykit? (
		kde? ( kde-apps/kdesu ) )
	policykit? ( sys-auth/polkit )

	>=sys-apps/util-linux-2.20
	>=sys-fs/e2fsprogs-1.41
	btrfs? ( sys-fs/btrfs-progs )
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
	xfs? ( sys-fs/xfsprogs sys-fs/xfsdump )
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/gnome-doc-utils
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	sed -i -e 's:Exec=@gksuprog@ :Exec=:' gparted.desktop.in.in || die
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--enable-doc \
		--enable-online-resize \
		GKSUPROG=$(type -P true)
}

src_install() {
	gnome2_src_install

	local _ddir="${D}"/usr/share/applications

	if use policykit; then
		sed -i -e 's:/usr/sbin/gparted %f:gparted-pkexec:' "${_ddir}"/gparted.desktop
		insinto /usr/share/polkit-1/actions/
		doins "${FILESDIR}"/org.gentoo.pkexec.gparted.policy
		dobin "${FILESDIR}"/gparted-pkexec
	else
		if use kde; then
			cp "${_ddir}"/gparted{,-kde}.desktop
			sed -i -e 's:Exec=:Exec=kdesu :' "${_ddir}"/gparted-kde.desktop
			echo 'OnlyShowIn=KDE;' >> "${_ddir}"/gparted-kde.desktop
		fi
	fi
}
