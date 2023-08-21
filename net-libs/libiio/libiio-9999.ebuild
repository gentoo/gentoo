# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..12} )

inherit cmake udev python-single-r1

DESCRIPTION="Library for interfacing with IIO devices"
HOMEPAGE="https://github.com/analogdevicesinc/libiio"
if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/analogdevicesinc/libiio"
	inherit git-r3
else
	SRC_URI="https://github.com/analogdevicesinc/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~riscv ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
IUSE="+aio python +zeroconf"

BDEPEND="python? ( ${PYTHON_DEPS} )"
RDEPEND="python? ( ${PYTHON_DEPS} )
	dev-libs/libxml2
	virtual/libusb:1
	aio? ( dev-libs/libaio )
	zeroconf? ( net-dns/avahi[dbus] )"
DEPEND="${RDEPEND}"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

src_configure() {
	local mycmakeargs=(
		-DHAVE_DNS_SD="$(usex zeroconf)"
		-DWITH_AIO="$(usex aio)"
		-DPYTHON_BINDINGS="$(usex python)"
	)
	use python && mycmakeargs+=(-DPYTHON_EXECUTABLE="${PYTHON}")
	cmake_src_configure
}

src_install() {
	cmake_src_install
	python_fix_shebang "${ED}"
	python_optimize
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
