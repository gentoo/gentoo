# Copyright 2012-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils vcs-snapshot

DESCRIPTION="Rime Input Method Engine, the core library"
HOMEPAGE="https://rime.im/ https://github.com/rime/librime"
SRC_URI="https://github.com/rime/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/1"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="app-i18n/opencc:=
	dev-cpp/glog:=
	dev-cpp/yaml-cpp:=
	dev-libs/boost:=[nls,threads]
	dev-libs/leveldb:=
	dev-libs/marisa:="
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	test? ( dev-cpp/gtest )"

DOCS=( {CHANGELOG,README}.md )

src_configure() {
	local mycmakeargs=(
		-DBUILD_TEST=$(usex test)
		-DBOOST_USE_CXX11=ON
		-DLIB_INSTALL_DIR="${EPREFIX}"/usr/$(get_libdir)
	)
	cmake-utils_src_configure
}
