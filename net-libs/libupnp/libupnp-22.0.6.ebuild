# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="pupnp"

DESCRIPTION="An Portable Open Source UPnP Development Kit"
HOMEPAGE="http://pupnp.sourceforge.net/"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-release-${PV}"

LICENSE="BSD"
SLOT="0/22"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="blocking-tcp debug doc +reuseaddr samples +ssl static-libs"

RDEPEND="ssl? ( dev-libs/openssl:0= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-22.0.4-disable-network-tests.patch" )

src_configure() {
	local mycmakeargs=(
		-DUPNP_BUILD_SAMPLES="$(usex samples ON OFF)"
		-DUPNP_BUILD_STATIC="$(usex static-libs ON OFF)"
		-DUPNP_ENABLE_BLOCKING_TCP_CONNECTIONS="$(usex blocking-tcp ON OFF)"
		-DUPNP_ENABLE_DEBUG="$(usex debug ON OFF)"
		-DUPNP_ENABLE_IPV6="ON"
		-DUPNP_ENABLE_OPEN_SSL="$(usex ssl ON OFF)"
		-DUPNP_MINISERVER_REUSEADDR="$(usex reuseaddr ON OFF)"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	use doc && dodoc docs/UPnP_Programming_Guide.pdf
	find "${ED}" -name '*.la' -delete || die
}
