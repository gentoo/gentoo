# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools udev

if [[ ${PV} = "9999" ]]; then
	EGIT_REPO_URI="https://github.com/wroberts/rogauracore.git"
	inherit git-r3
else
	SRC_URI="https://github.com/wroberts/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="RGB keyboard control for Asus ROG laptops"
HOMEPAGE="https://github.com/wroberts/rogauracore"
LICENSE="MIT"
SLOT="0"

DEPEND="virtual/libusb:="
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf
}

src_compile() {
	emake
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
