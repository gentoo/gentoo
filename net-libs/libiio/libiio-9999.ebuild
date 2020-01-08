# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Library for interfacing with IIO devices"
HOMEPAGE="https://github.com/analogdevicesinc/libiio"
if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/analogdevicesinc/libiio"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/analogdevicesinc/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
IUSE="+aio +zeroconf"

RDEPEND="dev-libs/libxml2:=
	virtual/libusb:1=
	aio? ( dev-libs/libaio )
	zeroconf? ( net-dns/avahi )"
DEPEND="${RDEPEND}"
