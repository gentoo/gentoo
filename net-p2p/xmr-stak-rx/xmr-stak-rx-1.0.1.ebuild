# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils systemd

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/fireice-uk/xmr-stak.git"
	EGIT_BRANCH="xmr-stak-rx-dev"
	inherit git-r3
	SRC_URI=""
else
	SRC_URI="https://github.com/fireice-uk/xmr-stak/archive/${PV}-rx.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/xmr-stak-${PV}-rx"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Monero RandomX Miner"
HOMEPAGE="https://github.com/fireice-uk/xmr-stak"
LICENSE="GPL-3"
SLOT="0"
IUSE="cuda hwloc opencl ssl webserver"

DEPEND="cuda? ( dev-util/nvidia-cuda-toolkit )
	hwloc? ( sys-apps/hwloc )
	opencl? ( virtual/opencl )
	ssl? ( dev-libs/openssl:0= )
	webserver? ( net-libs/libmicrohttpd )"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake-utils_src_prepare
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
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	systemd_newunit "${FILESDIR}"/${PN}.service ${PN}.service
	doinitd "${FILESDIR}"/${PN}
	dodir /etc/xmr-stak-rx
}

pkg_postinst() {
	if [ ! -e "${ROOT}/etc/xmr-stak-rx/main.config" ]; then
		ewarn "To use xmr-stack-rx:"
		if use cuda || use opencl; then
			ewarn "As root or as a user that is a member of the 'video' group,"
		fi
		ewarn "run:"
		ewarn "/usr/bin/xmr-stak-rx --cpu /etc/xmr-stak-rx/cpu.config --amd /etc/xmr-stak-rx/amd.config --nvidia /etc/xmr-stak-rx/nvidia.config -c /etc/xmr-stak-rx/main.config -C /etc/xmr-stak-rx/pools.txt"
		ewarn "xmr-stak-rx can now be terminated and 'systemctl start xmr-stak-rx' or '/etc/init.d/xmr-stak-rx start' can be used."
	fi
}
