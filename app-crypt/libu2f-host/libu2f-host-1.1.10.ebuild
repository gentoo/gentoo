# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info udev

DESCRIPTION="Yubico Universal 2nd Factor (U2F) Host C Library"
HOMEPAGE="https://developers.yubico.com/libu2f-host/"
SRC_URI="https://developers.yubico.com/${PN}/Releases/${P}.tar.xz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE="kernel_linux static-libs systemd"

DEPEND="dev-libs/hidapi
	dev-libs/json-c:="
# The U2F device node will be owned by group 'plugdev'
# in non-systemd configurations
RDEPEND="${DEPEND}
	!systemd? ( acct-group/plugdev )
	systemd? ( sys-apps/systemd[acl] )"
BDEPEND="virtual/pkgconfig"

CONFIG_CHECK="~HIDRAW"

src_install() {
	default
	if use kernel_linux; then
		udev_dorules 70-u2f.rules
	fi

	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	if ! use systemd; then
		elog "Users must be a member of the 'plugdev' group"
		elog "to be able to access U2F devices"
	fi
}
