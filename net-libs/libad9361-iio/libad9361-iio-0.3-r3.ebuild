# Copyright 1999-2025 Gentoo Authors
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
	KEYWORDS="amd64 ~arm ~riscv ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
IUSE="doc"

RDEPEND="net-libs/libiio:="
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-text/doxygen )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.2-fix-lld-tests.patch
	"${FILESDIR}"/${PN}-0.2-libdir-pkgconfig.patch
	"${FILESDIR}"/${PN}-0.3-cmake-gnuinstalldirs.patch
	"${FILESDIR}"/${PN}-0.3-cmake4.patch
)

src_configure() {
	local mycmakeargs=(
		-DWITH_DOC="$(usex doc)"
		-DCMAKE_INSTALL_DOCDIR="/usr/share/doc/${P}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	if use doc; then
		mv "${ED}/usr/share/doc/ad93610-doc" "${ED}/usr/share/doc/${PF}" || die
	fi
}
