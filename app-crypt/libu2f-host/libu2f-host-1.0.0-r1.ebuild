# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils linux-info udev user

DESCRIPTION="Yubico Universal 2nd Factor (U2F) Host C Library"
HOMEPAGE="https://developers.yubico.com/libu2f-host/"
SRC_URI="https://developers.yubico.com/${PN}/Releases/${P}.tar.xz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kernel_linux static-libs systemd"

RDEPEND="
	dev-libs/hidapi
	dev-libs/json-c"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
RDEPEND="${RDEPEND}
	systemd? ( sys-apps/systemd[acl] )"

CONFIG_CHECK="~HIDRAW"

pkg_setup() {
	# The U2F device node will be owned by group 'plugdev'
	# in non-systemd configurations
	if ! use systemd; then
		enewgroup plugdev
	fi
}

src_prepare() {
	autotools-utils_src_prepare

	sed -e 's:TAG+="uaccess":MODE="0664", GROUP="plugdev":g' \
		70-u2f.rules > 70-u2f-udev.rules || die
}

src_configure() {
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	if use kernel_linux; then
		if use systemd; then
			udev_dorules 70-u2f.rules
		else
			udev_newrules 70-u2f-udev.rules 70-u2f.rules
		fi
	fi
}

pkg_postinst() {
	if ! use systemd; then
		elog "Users must be a member of the 'plugdev' group"
		elog "to be able to access U2F devices"
	fi
}
