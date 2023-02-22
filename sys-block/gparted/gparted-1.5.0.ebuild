# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome2 optfeature virtualx

DESCRIPTION="Partition editor for graphically managing your disk partitions"
HOMEPAGE="https://gparted.org/ https://gitlab.gnome.org/GNOME/gparted/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+ FDL-1.2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="kde policykit wayland"

DEPEND="
	!policykit? (
		kde? ( >=kde-plasma/kde-cli-tools-5.8.6-r1[kdesu] ) )
	policykit? ( >=sys-auth/polkit-0.102 )
	>=dev-cpp/glibmm-2.56.1:2
	>=dev-cpp/gtkmm-3.24:3.0
	>=dev-libs/glib-2.58.3-r1:2
	>=sys-block/parted-3.2:=
	>=dev-libs/libsigc++-2.10.1:2
"
RDEPEND="${DEPEND}
	>=sys-apps/util-linux-2.33.2
	wayland? ( x11-apps/xhost )
"
BDEPEND="
	app-text/docbook-xml-dtd:4.1.2
	>=dev-util/intltool-0.51.0-r2
	dev-util/itstool
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

	mv "${ED}"/usr/share/{appdata,metainfo}
}

src_test() {
	virtx emake check
}

pkg_postinst() {
	gnome2_pkg_postinst

	optfeature_header
	optfeature "BTRFS support"                   sys-fs/btrfs-progs
	optfeature "DMRAID support"                  sys-fs/dmraid sys-fs/multipath-tools
	optfeature "Encrypted device / LUKS support" sys-fs/cryptsetup
	optfeature "exFAT support"                   sys-fs/exfatprogs
	optfeature "EXT2/EXT3/EXT4 support"          sys-fs/e2fsprogs
	optfeature "F2FS support"                    sys-fs/f2fs-tools
	optfeature "FAT support"                     sys-fs/dosfstools sys-fs/mtools
	optfeature "HFS support"                     sys-fs/diskdev_cmds sys-fs/hfsutils virtual/udev
	optfeature "JFS support"                     sys-fs/jfsutils
	optfeature "MDADM support"                   sys-fs/mdadm
	optfeature "NTFS support"                    sys-fs/ntfs3g[ntfsprogs]
	optfeature "Reiser4 support"                 sys-fs/reiser4progs
	optfeature "ReiserFS support"                sys-fs/reiserfsprogs
	optfeature "UDF support"                     sys-fs/udftools
	optfeature "XFS support"                     sys-fs/xfsprogs sys-fs/xfsdump
}
