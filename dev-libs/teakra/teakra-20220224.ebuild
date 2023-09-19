# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ ${PV} == 20220224 ]] && COMMIT=01db7cdd00aabcce559a8dddce8798dabb71949b

inherit cmake

DESCRIPTION="Emulator, assembler, etc for XpertTeak, the DSP used by DSi/3DS"
HOMEPAGE="https://github.com/wwylele/teakra/"
SRC_URI="https://github.com/wwylele/${PN}/archive/${COMMIT}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	sed -i "s|-Werror||g" "${S}"/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local -a mycmakeargs=(
		-DCMAKE_SKIP_RPATCOMMIT=ON
	)
	cmake_src_configure
}

src_test() {
	LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:"${BUILD_DIR}"/src/ cmake_src_test
}

src_install() {
	dolib.so "${BUILD_DIR}"/src/lib${PN}.so "${BUILD_DIR}"/src/lib${PN}_c.so

	insinto /usr/include
	doins -r include/${PN}

	einstalldocs
}
