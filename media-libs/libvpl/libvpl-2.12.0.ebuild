# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib optfeature flag-o-matic

DESCRIPTION="Intel Video Processing Library dispatcher"
HOMEPAGE="https://github.com/intel/libvpl/"
SRC_URI="https://github.com/intel/libvpl/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/2"
KEYWORDS="~amd64"

IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	x11-libs/libpciaccess[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	filter-lto
	cmake_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_TESTS="$(usex test)"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
	)
	cmake_src_configure
}

multilib_src_install() {
	cmake_src_install
	# Remove these license files
	rm -r "${ED}/usr/share/vpl/licensing" || die
}

pkg_postinst() {
	optfeature_header "This package provides only the dispatcher, to use it install one or more implementations"
	optfeature "CPUs" media-libs/oneVPL-cpu
	optfeature "Intel GPUs newer then, and including, Intel Xe" media-libs/oneVPL-intel-gpu
	optfeature "Intel GPUs older then Intel Xe" media-libs/intel-mediasdk
}
