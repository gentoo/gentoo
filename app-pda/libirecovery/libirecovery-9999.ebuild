# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools git-r3

DESCRIPTION="A cross-platform library to interface with Apple's iBoot via USB."
HOMEPAGE="http://www.libimobiledevice.org"
EGIT_REPO_URI="https://github.com/libimobiledevice/libirecovery.git"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0/6"
KEYWORDS=""
IUSE="udev"

RDEPEND=">=dev-libs/libusb-1.0.3:1=
	sys-libs/readline:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( README )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_with udev)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
