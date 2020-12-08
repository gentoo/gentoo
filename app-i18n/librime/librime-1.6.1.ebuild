# Copyright 2012-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cmake

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/rime/librime"
	EGIT_SUBMODULES=()
fi

DESCRIPTION="RIME (Rime Input Method Engine) core library"
HOMEPAGE="https://rime.im/ https://github.com/rime/librime"
LUA_COMMIT_ID="aeb1e9d76e704dd5472e70e7d3e2b25fcec93f23"
OCTAGRAM_COMMIT_ID="3664bc9d0426397541e6dcfb7c3c7d6aaad73b2e"
CHARCODE_COMMIT_ID="8f019bcec09d010b155cea111ae72f08e68f79ca"

if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/rime/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/hchunhui/librime-lua/archive/${LUA_COMMIT_ID}/librime-lua-${LUA_COMMIT_ID}.tar.gz
	https://github.com/lotem/librime-octagram/archive/${OCTAGRAM_COMMIT_ID}/librime-octagram-${OCTAGRAM_COMMIT_ID}.tar.gz
	https://github.com/rime/librime-charcode/archive/${CHARCODE_COMMIT_ID}/librime-charcode-${CHARCODE_COMMIT_ID}.tar.gz"
fi

LICENSE="BSD"
SLOT="0/1"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="lua octagram charcode debug test"
RESTRICT="!test? ( test )"

BDEPEND=""
RDEPEND="app-i18n/opencc:0=
	>=dev-cpp/glog-0.3.5:0=
	dev-cpp/yaml-cpp:0=
	dev-libs/boost:0=[nls,threads]
	dev-libs/leveldb:0=
	dev-libs/marisa:0=
	dev-libs/capnproto:0="
DEPEND="${RDEPEND}
	dev-libs/darts
	dev-libs/utfcpp
	x11-base/xorg-proto
	test? ( dev-cpp/gtest )
	lua? ( dev-lang/lua )"

DOCS=(CHANGELOG.md README.md)

src_prepare() {
	# Use headers of dev-libs/darts, dev-libs/utfcpp and x11-base/xorg-proto.
	sed -e "/\${PROJECT_SOURCE_DIR}\/thirdparty/d" -i CMakeLists.txt || die
	rm -r thirdparty.mk || die

	if use lua; then
		ln -sf "${WORKDIR}"/librime-lua-${LUA_COMMIT_ID} plugins/librime-lua
	fi

	if use octagram; then
		ln -sf "${WORKDIR}"/librime-octagram-${OCTAGRAM_COMMIT_ID} plugins/librime-octagram
	fi

	if use charcode; then
		ln -sf "${WORKDIR}"/librime-charcode-${CHARCODE_COMMIT_ID} plugins/librime-charcode
	fi

	cmake_src_prepare
}

src_configure() {
	local -x CXXFLAGS="${CXXFLAGS} -I${ESYSROOT}/usr/include/utf8cpp"

	if use debug; then
		CXXFLAGS+=" -DDCHECK_ALWAYS_ON"
	else
		CXXFLAGS+=" -DNDEBUG"
	fi

	local mycmakeargs=(
		-DBOOST_USE_CXX11=ON
		-DBUILD_TEST=$(usex test ON OFF)
		-DCMAKE_DISABLE_FIND_PACKAGE_Gflags=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Iconv=ON
		-DLIB_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)"
	)

	cmake_src_configure
}
