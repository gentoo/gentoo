# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info systemd

DESCRIPTION="A utility for management and user-mode mounting of encrypted filesystems"
HOMEPAGE="http://cryptmount.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="nls +ssl systemd"

DOCS=( AUTHORS ChangeLog NEWS README RELNOTES ToDo )

RDEPEND="
	dev-libs/libgcrypt:0=
	nls? ( virtual/libintl )
	ssl? ( dev-libs/openssl:0= )
	systemd? ( sys-apps/systemd )"

DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )"

CONFIG_CHECK="BLK_DEV_DM"
ERROR_BLK_DEV_DM="Please enable Device mapper support in your kernel config
	-> Device Drivers
		-> Multi-device support (RAID and LVM)
			-> Multiple devices driver support (RAID and LVM) (MD)
				<M> Device mapper support"

src_configure() {
	econf \
		--enable-cswap \
		--enable-delegation \
		--enable-fsck \
		--enable-luks \
		--with-libgcrypt \
		$(use_enable nls) \
		$(use_enable ssl openssl-compat) \
		$(use_with systemd)
}

src_install() {
	default
}
