# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/libdivecomputer/libdivecomputer"
	inherit autotools git-r3
else
	SRC_URI="https://www.libdivecomputer.org/releases/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Library for communication with dive computers from various manufacturers."
HOMEPAGE="https://www.libdivecomputer.org"
LICENSE="LGPL-2.1"

SLOT="0"
IUSE="bluetooth"

RDEPEND="virtual/libusb:1
	bluetooth? ( net-wireless/bluez )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	[[ -v EGIT_REPO_URI ]] && eautoreconf
}

src_configure() {
	econf $(use_with bluetooth bluez)
}
