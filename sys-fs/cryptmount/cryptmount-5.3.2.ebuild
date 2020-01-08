# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info systemd

DESCRIPTION="A utility for management and user-mode mounting of encrypted filesystems"
HOMEPAGE="http://cryptmount.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="argv0switch cswap fsck +gcrypt +largefile mount +nls +luks +openssl selinux systemd udev"
REQUIRED_USE="
	luks? ( gcrypt )
	openssl? ( gcrypt )
"

RDEPEND="
	gcrypt? ( dev-libs/libgcrypt:0= )
	luks? ( sys-fs/cryptsetup )
	openssl? ( dev-libs/openssl:0= )
	systemd? ( sys-apps/systemd )
	udev? ( virtual/udev )
	virtual/libiconv
	virtual/libintl
"

DEPEND="
	${RDEPEND}
	sys-kernel/linux-headers
"

BDEPEND="nls? ( sys-devel/gettext )"

DOCS=( "AUTHORS" "ChangeLog" "NEWS" "README" "README.sshfs" "RELNOTES" "ToDo" )

CONFIG_CHECK="BLK_DEV_DM"
ERROR_BLK_DEV_DM="
	Please enable Device Mapper support in your kernel config
	-> Device Drivers
		-> Multiple devices driver support (RAID and LVM)
			-> Multiple devices driver support (RAID and LVM)
				<*>/<M> Device mapper support
"

src_prepare() {
	default

	# Since SELinux is hardcoded, remove it on disabled SELinux profile
	if ! use selinux; then
		sed -e '/selinux/d' -i dmutils.c || die
	fi
}

src_configure() {
	local myeconf=(
		--disable-rpath
		$(use_enable argv0switch)
		$(use_enable cswap)
		$(use_enable fsck)
		$(use_with gcrypt libgcrypt)
		$(use_enable largefile)
		$(use_enable mount delegation)
		$(use_enable nls)
		$(use_enable luks)
		$(use_enable openssl openssl-compat)
		$(use_with systemd)
		$(use_enable udev libudev)

	)

	econf "${myeconf[@]}"
}
