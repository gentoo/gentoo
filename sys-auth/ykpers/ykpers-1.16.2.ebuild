# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils udev

DESCRIPTION="Library and tool for personalization of Yubico's YubiKey"
SRC_URI="http://yubico.github.io/yubikey-personalization/releases/${P}.tar.gz"
HOMEPAGE="https://github.com/Yubico/yubikey-personalization"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="BSD-2"
IUSE="static-libs consolekit"

RDEPEND="
	>=sys-auth/libyubikey-1.6
	virtual/libusb:1"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
RDEPEND="${RDEPEND}
	consolekit? ( sys-auth/consolekit[acl] )"

src_install() {
	DOCS=( doc/. AUTHORS ChangeLog NEWS README )
	autotools-utils_src_install

	use consolekit && udev_dorules *.rules
}
