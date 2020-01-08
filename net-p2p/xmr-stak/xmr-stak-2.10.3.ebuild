# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake systemd

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/fireice-uk/xmr-stak.git"
	EGIT_BRANCH="dev"
	inherit git-r3
	SRC_URI=""
else
	SRC_URI="https://github.com/fireice-uk/xmr-stak/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Unified all-in-one Monero miner"
HOMEPAGE="https://github.com/fireice-uk/xmr-stak"
LICENSE="GPL-3"
SLOT="0"
IUSE="cuda devfee hwloc opencl ssl webserver"

DEPEND="cuda? ( dev-util/nvidia-cuda-toolkit )
	hwloc? ( sys-apps/hwloc )
	opencl? ( virtual/opencl )
	ssl? ( dev-libs/openssl:0= )
	webserver? ( net-libs/libmicrohttpd )"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake_src_prepare
	if ! use devfee; then
		sed -i -e 's!fDevDonationLevel = .*;!fDevDonationLevel = 0.0;!' xmrstak/donate-level.hpp || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCUDA_ENABLE=$(usex cuda)
		-DHWLOC_ENABLE=$(usex hwloc)
		-DMICROHTTPD_ENABLE=$(usex webserver)
		-DOpenCL_ENABLE=$(usex opencl)
		-DOpenSSL_ENABLE=$(usex ssl)
		-DLIBRARY_OUTPUT_PATH=$(get_libdir)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	systemd_newunit "${FILESDIR}"/${PN}-2.3.0.service ${PN}.service
	doinitd "${FILESDIR}"/${PN}
	dodir /etc/xmr-stak
}

pkg_postinst() {
	if [ ! -e "${ROOT}/etc/xmr-stak/main.config" ]; then
		ewarn "To use xmr-stack:"
		if use cuda || use opencl; then
			ewarn "As root or as a user that is a member of the 'video' group,"
		fi
		ewarn "run:"
		ewarn "/usr/bin/xmr-stak --cpu /etc/xmr-stak/cpu.config --amd /etc/xmr-stak/amd.config --nvidia /etc/xmr-stak/nvidia.config -c /etc/xmr-stak/main.config -C /etc/xmr-stak/pools.txt"
		ewarn "xmr-stak can now be terminated and 'systemctl start xmr-stak' or '/etc/init.d/xmr-stak start' can be used."
	fi
}
