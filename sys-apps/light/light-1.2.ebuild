# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Program to easily change brightness on backlight-controllers."
HOMEPAGE="https://github.com/haikarainen/light"
SRC_URI="https://github.com/haikarainen/light/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="udev"
DEPEND="udev? ( virtual/udev )"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_with udev udev /lib/udev/rules.d)
}
