# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/aarond10/https_dns_proxy.git"
	inherit git-r3
else
	COMMIT="2d9285e2b94bce21c588c8160f8fac660806987a"
	SRC_URI="https://github.com/aarond10/https_dns_proxy/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${COMMIT}"
fi

DESCRIPTION="Lightweight DNS-over-HTTPS proxy"
HOMEPAGE="https://github.com/aarond10/https_dns_proxy"

LICENSE="MIT"
SLOT="0"

RDEPEND="
	dev-libs/libev
	net-dns/c-ares
	net-misc/curl[http2,ssl]"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_GTest=ON
		-DCLANG_TIDY_EXE=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	dobin "${BUILD_DIR}"/https_dns_proxy
}
