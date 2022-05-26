# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A size profiler for binaries"
HOMEPAGE="https://github.com/google/bloaty"
LICENSE="Apache-2.0"
SLOT="0"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/google/${PN}"
	IUSE="test"
	RESTRICT="!test? ( test )"
else
	SRC_URI="https://github.com/google/${PN}/releases/download/v${PV}/${P}.tar.bz2"
	KEYWORDS="amd64"
fi

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	dev-libs/capstone:=
	dev-libs/protobuf:=
	dev-libs/re2:=
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBLOATY_ENABLE_CMAKETARGETS=OFF
		-DBUILD_SHARED_LIBS=OFF
	)
	if [[ ${PV} == 9999 ]]; then
		mycmakeargs+=(
			-DBUILD_TESTING=$(usex test)
			$(usex test -DINSTALL_GTEST=OFF "")
		)
	fi
	cmake_src_configure
}
