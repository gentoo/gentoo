# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/aarond10/https_dns_proxy.git"
	inherit git-r3
else
	MY_COMMIT="2d9285e2b94bce21c588c8160f8fac660806987a"
	SRC_URI="https://github.com/aarond10/https_dns_proxy/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_COMMIT}"
fi

DESCRIPTION="A lightweight DNS-over-HTTPS proxy"
HOMEPAGE="https://github.com/aarond10/https_dns_proxy"

LICENSE="MIT"
SLOT="0"

DEPEND="dev-libs/libev
	net-dns/c-ares
	net-misc/curl[http2,ssl]"
RDEPEND="${DEPEND}"

src_install() {
	cmake_src_install
	dobin "${WORKDIR}/${P}_build/https_dns_proxy"
}
