# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake plocale

DESCRIPTION="C library for creating Excel XLSX files"
HOMEPAGE="https://libxlsxwriter.github.io/ https://github.com/jmcnamara/libxlsxwriter"
SRC_URI="https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-RELEASE_${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~x86"
IUSE="openssl"

DEPEND="
	sys-libs/zlib[minizip]
	openssl? ( dev-libs/openssl:= )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-findzlib.patch"
)

src_configure() {
	DOUBLEFUNCTION=OFF
	for x in $(plocale_get_locales); do
		if ! [[ "${x}" =~ ^en* ]]; then
			#non-english locale detected; apply double function fix
			DOUBLEFUNCTION=ON
			break
		fi
	done
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DUSE_OPENSSL_MD5="$(usex openssl)"
		-DUSE_SYSTEM_MINIZIP=ON
		-DUSE_DTOA_LIBRARY=${DOUBLEFUNCTION}
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	dodoc CONTRIBUTING.md License.txt Readme.md Changes.txt
	dodoc -r docs examples
}
