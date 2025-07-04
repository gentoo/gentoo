# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake fcaps

DESCRIPTION="Fast network scanner designed for Internet-wide network surveys"
HOMEPAGE="https://zmap.io/"
SRC_URI="https://github.com/zmap/zmap/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 x86"
IUSE="cpu_flags_x86_aes"

RDEPEND="
	dev-libs/gmp:=
	dev-libs/json-c:=
	dev-libs/judy
	dev-libs/libunistring:=
	net-libs/libpcap
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-alternatives/lex
	dev-util/byacc
	dev-util/gengetopt
	virtual/pkgconfig
"

FILECAPS=( cap_net_raw=ep usr/sbin/zmap )

PATCHES=(
	"${FILESDIR}"/${PN}-4.3.2-pkgconfig.patch
	# Merged. To be removed at next version.
	"${FILESDIR}"/${PN}-4.3.2-cmake.patch
)

DOCS=( AUTHORS CHANGELOG.md README.md examples )

src_configure() {
	local mycmakeargs=(
		-DENABLE_DEVELOPMENT=OFF
		-DFORCE_CONF_INSTALL=ON
		-DWITH_AES_HW=$(usex cpu_flags_x86_aes)
		# no module in ::gentoo for now
		-DWITH_NETMAP=OFF
		-DWITH_WERROR=OFF
	)

	cmake_src_configure
}
