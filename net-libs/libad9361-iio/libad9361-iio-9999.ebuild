# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="IIO AD9361 library for filter design and handling, multi-chip sync, etc"
HOMEPAGE="https://github.com/analogdevicesinc/libad9361-iio"
if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/analogdevicesinc/libad9361-iio"
	inherit git-r3
else
	SRC_URI="https://github.com/analogdevicesinc/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~riscv ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0/${PV}"

RDEPEND="net-libs/libiio:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.2-fix-lld-tests.patch
	"${FILESDIR}"/${PN}-0.2-libdir-pkgconfig.patch
	"${FILESDIR}"/${PN}-0.2-cmake-gnuinstalldirs.patch
)
