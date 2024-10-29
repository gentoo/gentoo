# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A tool to interact with the installation_proxy of an Apple's iDevice"
HOMEPAGE="https://libimobiledevice.org"
SRC_URI="https://github.com/libimobiledevice/ideviceinstaller/releases/download/${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND=">=app-pda/libimobiledevice-1.3.0:=
	>=app-pda/libplist-2.3.0:=
	>=dev-libs/libzip-0.8"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	sed -i -e 's:-Werror -g::' configure || die
}
