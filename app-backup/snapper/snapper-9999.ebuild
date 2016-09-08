# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_REPO_URI="git://github.com/openSUSE/snapper.git"
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
inherit eutils autotools-utils git-r3

DESCRIPTION="Command-line program for btrfs and ext4 snapshot management"
HOMEPAGE="http://snapper.io/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+btrfs ext4 lvm pam xattr"

RDEPEND="dev-libs/boost[threads]
	dev-libs/libxml2
	dev-libs/icu:=
	sys-apps/acl
	sys-apps/dbus
	sys-apps/util-linux
	sys-libs/zlib
	virtual/libintl
	btrfs? ( >=sys-fs/btrfs-progs-3.17.1 )
	ext4? ( sys-fs/e2fsprogs )
	lvm? ( sys-fs/lvm2 )
	pam? ( sys-libs/pam )
	xattr? ( sys-apps/attr )"

DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

REQUIRED_USE="|| ( btrfs ext4 lvm )"

DOCS=( AUTHORS package/snapper.changes )

PATCHES=( "${FILESDIR}"/cron-confd.patch )

src_configure() {
	local myeconfargs=(
		--with-conf="/etc/conf.d"
		--docdir="/usr/share/doc/${PF}"
		--disable-zypp
		--enable-rollback
		$(use_enable btrfs)
		$(use_enable ext4)
		$(use_enable lvm)
		$(use_enable pam)
		$(use_enable xattr xattrs)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	# Existing configuration file required to function
	newconfd data/sysconfig.snapper snapper
}

pkg_postinst() {
	elog "In order to use Snapper, you need to set up"
	elog "at least one config first. To do this, run:"
	elog "snapper create-config <subvolume>"
	elog "For more information, see man (8) snapper or"
	elog "http://snapper.io/documentation.html"
}
