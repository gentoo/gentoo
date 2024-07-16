# Copyright 2012-2024 Gentoo Authors
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
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/rime/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="BSD"
SLOT="0/1-${PV}"
KEYWORDS="amd64 arm64 ~loong ppc ppc64 ~riscv x86"
IUSE="debug test"
RESTRICT="!test? ( test )"

BDEPEND="dev-libs/capnproto:0"
RDEPEND="app-i18n/opencc:0=
	>=dev-cpp/glog-0.3.5:0=
	dev-cpp/yaml-cpp:0=
	dev-libs/boost:=
	dev-libs/capnproto:0=
	dev-libs/leveldb:0=
	dev-libs/marisa:0="
DEPEND="${RDEPEND}
	dev-libs/darts
	dev-libs/utfcpp
	x11-base/xorg-proto
	test? ( dev-cpp/gtest )"

DOCS=(CHANGELOG.md README.md)

src_prepare() {
	eapply "${FILESDIR}/${PN}-1.6.0-boost-1.76.patch"
	eapply "${FILESDIR}/${PN}-1.7.3-boost-1.85.patch"

	# Use headers of dev-libs/darts, dev-libs/utfcpp and x11-base/xorg-proto.
	sed -e "/\${PROJECT_SOURCE_DIR}\/thirdparty/d" -i CMakeLists.txt || die
	rm -r thirdparty || die

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
		-DENABLE_EXTERNAL_PLUGINS=ON
		-DINSTALL_PRIVATE_HEADERS=ON
	)

	cmake_src_configure
}
