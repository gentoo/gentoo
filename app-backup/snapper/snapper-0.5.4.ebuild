# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd

DESCRIPTION="Command-line program for btrfs and ext4 snapshot management"
HOMEPAGE="http://snapper.io/"
SRC_URI="ftp://ftp.suse.com/pub/projects/snapper/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+btrfs ext4 lvm pam xattr"

RDEPEND="dev-libs/boost:=[threads]
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

PATCHES=(
	"${FILESDIR}"/cron-confd.patch
)

src_prepare() {
	default

	sed -e "s,/usr/lib/systemd/system,$(systemd_get_systemunitdir),g" \
		-i data/Makefile.* \
		|| die "Failed to fix systemd services and timers installation path"
}

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

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	# Existing configuration file required to function
	newconfd data/sysconfig.snapper snapper
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	elog "In order to use Snapper, you need to set up"
	elog "at least one config first. To do this, run:"
	elog "snapper create-config <subvolume>"
	elog "For more information, see man (8) snapper or"
	elog "http://snapper.io/documentation.html"
}
